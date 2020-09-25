module WickedPdfConcern
	extend ActiveSupport::Concern

	def wicked_pdf_options(file_name, template)
    { 
      pdf:              file_name,  template:       template,
      formats:          [:html],    page_size:      'A4',
      page_height:      250,        page_width:     300,
      encoding:         'utf-8',    orientation:    'Landscape',
      print_media_type: true,       outline: { outline:  true },
      layout: 'pdf',                show_as_html: params[:debug].present?,
      margin: { top: 20, left: 30, right: 30, bottom: 30 },
      footer: { content: footer_html, :encoding => 'utf-8' }
    }
  end

  private

  def footer_html
    ERB.new(pdf_template).result(binding)
  end

  def pdf_template
    File.read("#{Rails.root}/app/views/layouts/pdf/footer.html.erb")
  end
end