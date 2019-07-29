class NeighborhoodLinksController < ApplicationController
  before_action :set_neighborhood_link, only: [:show, :edit, :update, :destroy]

  def index
    @neighborhood_links = NeighborhoodLink.order({ date: :desc }, { title: :asc }).paginate(:page => params[:page], :per_page => 100)
    @neighborhood_link = NeighborhoodLink.new
    @neighborhoods = Building.where('neighborhood is not null').map(&:neighborhood)
  end

  def show
  end

  def new
    @neighborhood_link = NeighborhoodLink.new
  end

  def edit
  end

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

  def destroy
    @neighborhood_link.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Neighborhood link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_neighborhood_link
      @neighborhood_link = NeighborhoodLink.find(params[:id])
    end

    def neighborhood_link_params
      params.require(:neighborhood_link).permit(:neighborhood,:date,:title,:web_url,:source, :image, :parent_neighborhood)
    end
end
