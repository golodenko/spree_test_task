require 'spec_helper'
require "rails_helper"

SAMPLE_CSV_FILE_PATH = 'spec/fixtures/files/test.csv'
EMPTY_SAMPLE_CSV_FILE_PATH = 'spec/fixtures/files/empty.csv'

describe 'CSVProductParser' do
  context 'when valid CSV passed' do
    it 'returns aray of 3 papams hashes without empty keys' do
      parser = CSVProductParser.new(SAMPLE_CSV_FILE_PATH)
      result = parser.parse

      expect(result).to be_a(Array)
      expect(result.length).to eq(3)
      expect(result[0]['name']).to eq('Ruby on Rails Bag')
      expect(result[1]['name']).to eq('Spree Bag')
    end
  end

  context 'when empty CSV passed' do
    it 'returns aray of 0 papams hashes without empty keys' do
      parser = CSVProductParser.new(EMPTY_SAMPLE_CSV_FILE_PATH)
      result = parser.parse

      expect(result).to be_a(Array)
      expect(result.length).to eq(0)
    end
  end
end
