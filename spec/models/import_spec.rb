require 'spec_helper'
require "rails_helper"

SAMPLE_CSV_FILE_PATH = 'spec/fixtures/files/test.csv'
EMPTY_SAMPLE_CSV_FILE_PATH = 'spec/fixtures/files/empty.csv'

describe 'Import' do
  context 'CSV' do
    context 'when uploaded valid CSV file' do
      it 'adds 3 products to database' do
        import = FactoryBot.create(:import)
        allow_any_instance_of(Paperclip::Attachment).to receive(:path).and_return(SAMPLE_CSV_FILE_PATH)

        expect{import.import_products(CSVProductParser)}.to change(Spree::Product, :count).from(21).to(24)
      end
    end

    context 'when uploaded valid but empty file' do
      it 'makes not changes in DB' do
        import = FactoryBot.create(:import)
        allow_any_instance_of(Paperclip::Attachment).to receive(:path).and_return(EMPTY_SAMPLE_CSV_FILE_PATH)

        expect{import.import_products(CSVProductParser)}.not_to change(Spree::Product, :count)
      end
    end
  end
end
