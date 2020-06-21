class UploadsController < ApplicationController
  load_and_authorize_resource         only: [:documents]
  before_action :find_upload,         only: [:update, :edit, :destroy]
	before_action :authenticate_user!,  only: [:destroy]
  after_action  :clear_cache,         only: [:create, :destroy]

	def index
    if params[:building_id].present?
      @imageable = Building.find(params[:building_id])
    elsif params[:unit_id]
      @imageable     = Unit.find(params[:unit_id])
    elsif params[:featured_agent_id]
      @imageable = FeaturedAgent.find(params[:featured_agent_id])
    else
      @uploads = Upload.order('created_at desc').limit(52)
    end
    @uploads = @imageable.uploads.where('image_file_name is not null') if @imageable.present?

    respond_to do |format|
      format.html
      format.json { render json: { uploads: Upload.uploads_json_hash(@uploads) }, :status => 200 }
    end
	end

  def photos
    @photos = Upload.where('image_file_name is not null').paginate(params[:page], per_page: 50)
  end

  def documents
    @documents = Upload.where('document_file_name is not null').includes(:user, :imageable)
  end

  def rotate
    @image   = Upload.find(params[:id])
    rotation = params[:deg].to_f
    rotation ||= 90 # Optional, otherwise, check for nil!
    
    @image.rotate!(rotation)

    redirect_to :back, flash[:notice] => 'The image has been rotated'
  end

  def edit
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
      @imageable      = find_imageable
      @upload         = @imageable.uploads.build(upload_params)
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
    if @upload.destroy
      respond_to do |format|  
        format.html{ redirect_to :back, notice: 'File deleted.' }
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

  def clear_cache
    Rails.cache.clear()
  end

end
