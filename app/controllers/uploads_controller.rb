class UploadsController < ApplicationController
  #load_and_authorize_resource
	before_action :authenticate_user!, only: [:destroy]

	def index
    if params[:building_id].present?
      @building = Building.find(params[:building_id])
      @uploads = Upload.where("imageable_id = ? or imageable_id in (?)", @building.id, @building.units.map{|u| u.id}).order(:sort)
    elsif params[:unit_id]
      @unit = Unit.find(params[:unit_id])
      @uploads = @unit.uploads.order('created_at desc')
    else
      @uploads = Upload.order('created_at desc')
    end
    @uploads = @uploads.where('image_file_name is not null')

    respond_to do |format|
      format.html
      format.json { render json: { uploads: uploads_hash }, :status => 200 }
    end
	end

  def documents
    @documents = Upload.where('document_file_name is not null').includes(:user, :imageable)
  end

  def rotate
    @image = Upload.find(params[:id])
    rotation = params[:deg].to_f
    rotation ||= 90 # Optional, otherwise, check for nil!
    
    @image.rotate!(rotation)

    redirect_to :back, flash[:notice] => "The image has been rotated"
  end

	def new
    if params['buildings-search-txt'].present?
      address = params['buildings-search-txt'].split(',')[0]
      zipcode = params[:zip].present? ? params[:zip] : params['buildings-search-txt'].split('NY ').last 
      @imageable = Building.find_by_building_street_address_and_zipcode(address, zipcode)
  	else	
      if params[:building_id].present?
  			@imageable = Building.find(params[:building_id])
  		else
  			@imageable = Unit.find(params[:unit_id])
  		end
    end
  end

	def create
    unless upload_params[:file_uid].present?
      @imageable = find_imageable
      @upload = @imageable.uploads.build(upload_params)
      @upload.user_id = current_user.id if current_user.present?
    else
      @upload = Upload.new(upload_params)
    end
    if @upload.save
      respond_to do |format|
        # send success header
        format.js
        format.json { render json: { message: 'success', fileID: @upload.id }, :status => 200 }
      end
    else
      #  you need to send an error header, otherwise Dropzone
      #  will not interpret the response as an error:
      render json: { error: @upload.errors.full_messages.join(',')}, :status => 400
    end     
	end

  def update
    @upload = Upload.find(params[:id])
    # document = @upload.document
    # filename = URI.unescape(document.url).split('/').last #bucket file name[ex: 123.jpg]
    # renamefilename = upload_params[:document_file_name]
    # document.styles.keys+[:original].each do |style|
    #   old_path = document.path(style)
    #   new_path = new_path.gsub!("documents/#{filename}", "documents/#{renamefilename}")
    #   #rename_attachment(document, old_path, new_path)
    #   old_path = document.s3_bucket.objects.first
    #   document.s3_bucket.objects[old_path].move_to(new_path, acl: :public_read)
    # end
    # creds = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
    # aws_s3 = Aws::S3::Resource.new(credentials: creds, region: 'us-west-2')
    # bucket = aws_s3.bucket(ENV['AWS_S3_BUCKET'])
    #filename = URI.unescape(document.url).split('/').last
    # s3 = Aws::S3::Client.new( region: 'us-west-2',
    #                           credentials: creds)

    # s3.copy_object(bucket: ENV['AWS_S3_BUCKET'],
    #                copy_source: ENV['AWS_S3_BUCKET']+'/'+filename,
    #                key: upload_params[:document_file_name])

    # s3.delete_object(bucket: ENV['AWS_S3_BUCKET'],
    #                  key: "#{filename}f")
    
    #(document.styles.keys+[:original]).each do |style|
    #   debugger
    # filename = URI.unescape(document.url).split('/').last #bucket file name[ex: 123.jpg]
    # renamefilename = upload_params[:document_file_name]
    # obj = bucket.object(filename) # create object of original file name
    # # debugger
    # puts obj.inspect
    # obj.move_to("aptreviews-app/#{renamefilename}", acl: 'public-read')
    # puts "OUTPUT: #{obj.inspect}"
    # obj = bucket.object(renamefilename)

    #   #old_path = document.path(style)
    #   #new_path = old_path.gsub("#{@upload.document_file_name}", "#{upload_params[:document_file_name]}")

    #   #document.s3_bucket.objects.first.move_to(new_path, acl: :public_read)
    #   #extension = Paperclip::Interpolations.extension(@upload.document, style)
    #   # old_path = @upload.document.url
    #   # common_s3_path = @upload.document.url.split('original/')
    #   # new_path = common_s3_path[0]+"original/#{upload_params[:document_file_name]}?#{Time.now.to_i}"
    #   # aws_obj = @upload.document.s3_bucket.objects.first
    #   #aws_obj.move_to new_path, acl: :public_read, @upload.document.bucket_name
    # end
    # #s3 = Aws::S3::Client.new( region: 'us-west-2')
    #Aws::S3::Base.establish_connection!(:access_key_id =>ENV['AWS_ACCESS_KEY_ID'],:secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'])
    # TODO renaming files on AWS-S3
    # if params[:renaming_file].present?
    #   (@upload.document.styles.keys+[:original]).each do |style|
    #       debugger
    #       #path = @upload.document.url(style)
    #       #debugger
    #       #FileUtils.move(path, File.join(File.dirname(path), new_file_name))
    #       AWS::S3::S3Object.move_to(path, upload_params[:document_file_name], @upload.document.bucket_name
    #       #debugger
    #   end
    #   @upload.document_file_name = new_file_name
    #end
    #@upload.rename_file(params)
    
    ####***** RENAMING FILE CODE on AFTER UPDATE callback *****#####

    if @upload.update(upload_params)
      respond_to do |format|  
        format.html{ redirect_to :back, notice: 'File Updated.' }
        format.json { render json: { message: 'success' }, :status => 200 }
      end
    else
      render json: { message: @upload.errors.full_messages.join(',') }, :status => 400
    end
  end

	def destroy
    @upload = Upload.find(params[:id])
    if @upload.destroy
      respond_to do |format|  
        format.html{ redirect_to :back, notice: 'File deleted.' }
        format.json { render json: { message: "File deleted from server" } }
      end
    else
      render json: { message: @upload.errors.full_messages.join(',') }
    end
  end


	private

	def upload_params
		params.require(:upload).permit(:image, 
                                    :imageable_id, 
                                    :imageable_type, 
                                    :user_id, 
                                    :sort, 
                                    :rotation, 
                                    :document, 
                                    :document_file_name, 
                                    :file_uid)
	end

	def find_imageable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
  end

  #[{id: 12, image_url: ''},{id: 123, image_url: ''},{id: 124, image_url: ''}]

  def uploads_hash
    records = []
    @uploads.each do |upload|
      records << { id: upload.id, orig_image_url: upload.image.url,  date_uploaded: upload.created_at.strftime("%m/%d/%Y") }
    end
    records
  end

end
