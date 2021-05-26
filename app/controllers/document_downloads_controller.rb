class DocumentDownloadsController < ApplicationController
  load_and_authorize_resource
  before_action :set_unit, only: [:show, :edit, :update, :destroy]

  # GET /units
  # GET /units.json
  def index
    
  end

  def downloaders
    @downloads = DocumentDownload.all.to_a.uniq{|rec| rec.user_id}
  end

  # GET /units/1
  # GET /units/1.json
  def show
  
  end

  # GET /units/new
  def new
    
  end

  # GET /units/1/edit
  def edit
   
  end

  # POST /units
  # POST /units.json
  def create
    @document_download = DocumentDownload.new(document_download_params)
    respond_to do |format|
      if @document_download.save
        format.html { redirect_to request.referer, notice: 'Successfully created.' }
        format.json { render :json => @document_download }
      else
        format.html { render :new }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /units/1
  # PATCH/PUT /units/1.json
  def update
    @document_download.update(document_download_params)
    respond_to do |format|
      format.json { render json: @document_download }
    end
  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    @document_download.destroy
    respond_to do |format|
      format.html { redirect_to request.referer, notice: 'Successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def document_download_params
      params.require(:document_download).permit(:upload_id, :user_id)
    end
end
