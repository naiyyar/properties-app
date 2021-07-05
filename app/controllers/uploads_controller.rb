class UploadsController < ApplicationController
  load_and_authorize_resource        only: [:documents, :destroy]
  before_action :find_upload,        only: [:update, :edit, :destroy]
	before_action :authenticate_user!, only: [:destroy]

	def index
    @uploads = Upload.order('created_at desc').limit(52)

    respond_to do |format|
      format.html
      format.json { render json: { uploads: Upload.uploads_json_hash(@uploads) }, :status => 200 }
    end
	end

  # On drag and drop
  def set_sort_order
    object = params[:imageable_type].constantize.find(params[:imageable_id])
    uploads = object.uploads
    params[:order].each_pair do |key, value|
      uploads.find(value[:id]).update_columns(sort: key, updated_at: Time.now)
    end
    render json: { message: 'success' }, :status => 200
  end

  def photos
    @pagy, @photos = pagy(Upload.where('image_file_name is not null'), items: 50)
  end

  def rotate
    @image   = Upload.find(params[:id])
    rotation = params[:deg].to_f
    rotation ||= 90 # Optional, otherwise, check for nil!
    
    @image.rotate!(rotation)
    flash[:notice] = 'The image has been rotated'
    redirect_to request.referer
  end

  def edit
  end

	def new
    @upload_type = params[:upload_type]
    @imageable = Building.find(params[:building_id])
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
        format.html
        format.js
        format.json { 
          render json: { 
            message: 'success', 
            fileID: @upload.id,
            image_url: @upload.image.url,
            type: @upload.imageable_type
          }, 
          :status => 200 
        }
      end
    else
      render json: { error: @upload.errors.full_messages.join(',')}, :status => 400
    end     
	end

  def update
    if @upload.update(upload_params)
      respond_to do |format|  
        format.html{ redirect_to request.referer, notice: 'File Updated.' }
        format.js
        format.json { render json: { message: 'success' }, :status => 200 }
      end
    else
      render json: { message: @upload.errors.full_messages.join(',') }, :status => 400
    end
  end

	def destroy
    if @upload.destroy
      respond_to do |format|  
        format.html{ redirect_to request.referer, notice: 'File deleted.' }
        format.json { render json: { message: 'File deleted from server' } }
        format.js
      end
    else
      render json: { message: @upload.errors.full_messages.join(',') }
    end
  end


	private

  def find_upload
    @upload = Upload.find(params[:id])
  end

	def upload_params
		params.require(:upload).permit!
	end

	def find_imageable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
  end

end
