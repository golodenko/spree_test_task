require 'csv'

class CSVProductParser
  def initialize(file_path)
    @file = file_path
  end

  def parse
    hash_params = []
    rows = CSV.read(@file, headers: true, col_sep: CSV_IMPORT_SETTINGS[:default_separator], skip_lines: nil)
    rows.each do |row|
      hash = row.to_hash.delete_if { |k, v| k.nil? || v.nil? }
      hash_params << hash unless hash.empty?
    end
    hash_params
  end
end