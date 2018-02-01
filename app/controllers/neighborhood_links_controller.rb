class NeighborhoodLinksController < ApplicationController
  before_action :set_neighborhood_link, only: [:show, :edit, :update, :destroy]

  # GET /neighborhood_links
  # GET /neighborhood_links.json
  def index
    @neighborhood_links = NeighborhoodLink.order('created_at desc')
    @neighborhood_link = NeighborhoodLink.new
    @neighborhoods = Building.where('neighborhood is not null').map(&:neighborhood)
  end

  # GET /neighborhood_links/1
  # GET /neighborhood_links/1.json
  def show
  end

  # GET /neighborhood_links/new
  def new
    @neighborhood_link = NeighborhoodLink.new
  end

  # GET /neighborhood_links/1/edit
  def edit
  end

  # POST /neighborhood_links
  # POST /neighborhood_links.json
  def create
    @neighborhood_link = NeighborhoodLink.new(neighborhood_link_params)

    respond_to do |format|
      if @neighborhood_link.save
        @neighborhood_link.save_parent_neighborhood
        format.html { redirect_to :back, notice: 'Neighborhood link was successfully created.' }
        format.json { render :show, status: :created, location: @neighborhood_link }
      else
        format.html { render :new }
        format.json { render json: @neighborhood_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /neighborhood_links/1
  # PATCH/PUT /neighborhood_links/1.json
  def update
    @neighborhood_link.save_parent_neighborhood
    respond_to do |format|
      if @neighborhood_link.update(neighborhood_link_params)
        format.html { redirect_to :back, notice: 'Neighborhood link was successfully updated.' }
        format.json { render :show, status: :ok, location: @neighborhood_link }
      else
        format.html { render :edit }
        format.json { render json: @neighborhood_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /neighborhood_links/1
  # DELETE /neighborhood_links/1.json
  def destroy
    @neighborhood_link.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Neighborhood link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_neighborhood_link
      @neighborhood_link = NeighborhoodLink.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def neighborhood_link_params
      params.require(:neighborhood_link).permit(:neighborhood,:date,:title,:web_url,:source, :image, :parent_neighborhood)
    end
end
