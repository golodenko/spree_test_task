require 'spec_helper'
require "rails_helper"

SAMPL_CSV_FILE_PATH = 'spec/fixtures/files/test.csv'

describe 'Import' do
  describe "when uploaded valid CSV file" do
    it "adds 3 products to database" do
      import = FactoryBot.create(:import)
      allow_any_instance_of(Paperclip::Attachment).to receive(:path).and_return(SAMPL_CSV_FILE_PATH)

      expect{import.import_products(CSVProductParser.new)}.to change{Spree::Product.all.count}.from(21).to(24)
    end
  end
end
