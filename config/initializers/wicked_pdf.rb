if Rails.env.production?
	 WickedPdf.config ||= {}
	WickedPdf.config.merge!({
	  #extra configurations
	})
else
  WickedPdf.config = {
  :exe_path => '/usr/local/bin/wkhtmltopdf'
	}            
end