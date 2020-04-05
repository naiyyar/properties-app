class ImportService
	attr_accessor :file, :spreadsheet, :header
	
	def initialize file
		@file 			 			 = file
		@original_filename = @file.original_filename rescue nil
		@file_path 				 = @file.path rescue nil
		@spreadsheet 			 = open_spreadsheet
		@header 					 = @spreadsheet.row(1)
	end

	def open_spreadsheet
    case File.extname(@original_filename)
     when '.csv' then Roo::CSV.new(@file_path)
     when '.xls' then Roo::Excel.new(@file_path)
     when '.xlsx' then Roo::Excelx.new(@file_path)
     else raise "Unknown file type: #{@original_filename}"
    end
  end
end