class CSVProductParser
  def parse(csv_file)
    hash_params = []
    rows = CSV.read(csv_file, headers: true, col_sep: CSV_IMPORT_SETTINGS[:default_separator], skip_lines: nil)
    rows.each do |row|
      hash = row.to_hash.delete_if { |k, v| k.nil? || v.nil? }
      hash_params << hash unless hash.empty?
    end
    hash_params
  end
end