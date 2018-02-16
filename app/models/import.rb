class Import < ApplicationRecord
  require 'csv'

  has_attached_file :file
  validates_attachment_content_type :file, content_type: 'text/plain'

  # # TODO: do dependency injection for expandability
  def import_products(parser)
    create_aliases_for_mappings
    parser.parse(file.path).each do |params|
      product = create_product(only_valid_params(params))
      create_dependent_objects(product, params) if product.save!
    end
    abort('ss')
  end

  def create_dependent_objects(product, params)
    abort(params.to_s)
    fill_stock(product, params[CSV_IMPORT_SETTINGS[:stock_quantity_field]])
    assign_category(product, params[CSV_IMPORT_SETTINGS[:category_field]])
  end

  def only_valid_params(a)
    b = a
    b.delete_if { |k, v| k == CSV_IMPORT_SETTINGS[:stock_quantity_field] || k == CSV_IMPORT_SETTINGS[:category_field] }
  end

  def create_product(params)
    params[:shipping_category_id] = default_shipping_category.id
    product = Spree::Product.new(params)
    product.price = params['price'].gsub(',','.').to_d
    validate_product(product)
  end

  def validate_product(product)
    product.validate
    product.slug = generate_unique_slug(product.slug) if product.errors.messages.include?(:slug)
    product
  end

  def create_aliases_for_mappings
    Spree::Product.class_eval do
      CSV_IMPORT_SETTINGS[:custom_mappings].each do |csv_value, table_value|
        alias_attribute csv_value, table_value
      end
    end
  end

  def default_shipping_category
    Spree::ShippingCategory.first_or_create do |dc|
      dc.name = 'Default'
    end
  end

  def fill_stock(product, stock)
    abort(stock)
    product.master.stock_items.first_or_create.set_count_on_hand(stock)
  end

  def default_stock_location
    Spree::StockLocation.first_or_create(name: 'Default location')
  end

  def assign_category(product_id, category)
    puts 'assign category: #{category}'
    puts 'for item #:' + product_id.to_s
  end

  def generate_unique_slug(current_slug, num = 1)
    num += 1
    new_slug = "#{current_slug}-#{num}"
    return new_slug unless Spree::Product.find_by_slug(new_slug)
    generate_unique_slug(current_slug, num)
  end
end
