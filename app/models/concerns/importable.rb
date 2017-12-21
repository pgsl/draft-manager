module Importable

  extend ActiveSupport::Concern

  module ClassMethods # :nodoc:
    def open_spreadsheet(file)
      case File.extname(file.original_filename)
      when ".csv"  then    Roo::CSV.new(file.path)
      when ".xls"  then  Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file.path}"
      end
    end

  end

end
