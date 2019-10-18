# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:

Mime::Type.register "application/pdf", :pdf
Mime::Type.register "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :xlsx, [], %w(xlsx)
Mime::Type.register "application/vnd.ms-office", :xls, [], %w(xls)
Mime::Type.register "application/xls", :xls
#Mime::Type.register "text/plain", :text, [], %w(txt pem)
Mime::Type.register "application/vnd.ms-powerpoint", :ppt
Mime::Type.register "application/vnd.openxmlformats-officedocument.presentationml.presentation", :pptx
#Mime::Type.register "text/xml", :plist

