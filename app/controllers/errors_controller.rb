class ErrorsController < ApplicationController
  before_action :hide_search_bar
  
  def access_denied
    respond_to do |format|
      format.html { render status: 404 }
      format.json { render json: { error: 'Access Denied.' }, status: 404 }
    end
  end

  def not_found
  	respond_to do |format|
      format.html { render status: 404 }
      format.json { render json: { error: "Resource not found" }, status: 404 }
    end
  end

  def unacceptable
     respond_to do |format|
       format.html { render status: 422 }
       format.json { render json: { error: "Params unacceptable" }, status: 422 }
     end
   end

  def internal_server_error
  	respond_to do |format|
      format.html { render status: 500 }
      format.json { render json: { error: "Internal server error" }, status: 500 }
    end
  end

  def not_route_match
  end

  private

  def hide_search_bar
  	@search_bar_hidden = :hidden
  end

end
