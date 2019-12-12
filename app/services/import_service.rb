class ImportService
	attr_accessor :file, :spreadsheet, :header
	
	def initialize file
		@file 			 	= file
		@spreadsheet 	= open_spreadsheet(@file)
		@header 			= @spreadsheet.row(1)
	end

	def open_spreadsheet(file)
    case File.extname(file.original_filename)
     when '.csv' then Roo::CSV.new(file.path)
     when '.xls' then Roo::Excel.new(file.path)
     when '.xlsx' then Roo::Excelx.new(file.path)
     else raise "Unknown file type: #{file.original_filename}"
    end
  end
end