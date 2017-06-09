class UploadsController < ApplicationController
  load_and_authorize_resource
	before_action :authenticate_user!, only: [:destroy, :create]

	def index
    if params[:building_id]
      @building = Building.find(params[:building_id])
      @uploads = Upload.where("imageable_id = ? or imageable_id in (?)", @building.id, @building.units.map{|u| u.id})
    else
      @unit = Unit.find(params[:unit_id])
      @uploads = @unit.uploads.order('created_at desc')
    end
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
    session[:after_contribute] = 'upload' # if params[:contribution].present?
    @search_bar_hidden = :hidden
  end

	def create
    @imageable = find_imageable
    @upload = @imageable.uploads.build(upload_params)
    @upload.user_id = current_user.id if current_user.present?
    if @upload.save
      session[:after_contribute] = 'upload'
      # send success header
      render json: { message: 'success', fileID: @upload.id }, :status => 200
    else
      #  you need to send an error header, otherwise Dropzone
      #  will not interpret the response as an error:
      render json: { error: @upload.errors.full_messages.join(',')}, :status => 400
    end     
	end

	def destroy
    @upload = Upload.find(params[:id])
    if @upload.destroy    
      render json: { message: "File deleted from server" }
    else
      render json: { message: @upload.errors.full_messages.join(',') }
    end
  end


	private

		def upload_params
			params.require(:upload).permit(:image, :imageable_id, :imageable_type, :user_id)
		end

		def find_imageable
    params.each do |name, value|
      if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
      end
    end
  end

end
