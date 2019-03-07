class FeaturedCompsController < ApplicationController
  load_and_authorize_resource
  before_action :set_featured_comp, only: [:show, :edit, :update, :destroy]

  # GET /featured_comps
  # GET /featured_comps.json
  def index
    @filterrific = initialize_filterrific(
      FeaturedComp,
      params[:filterrific],
      available_filters: [:search_query]
    ) or return
    @featured_comps = @filterrific.find.paginate(:page => params[:page], :per_page => 100).includes(:building, :buildings).order('created_at desc')

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /featured_comps/1
  # GET /featured_comps/1.json
  def show
  end

  # GET /featured_comps/new
  def new
    @featured_comp = FeaturedComp.new
  end

  # GET /featured_comps/1/edit
  def edit
    @featured_on_buildings = @featured_comp.buildings.paginate(:page => params[:page], :per_page => 20)
  end

  # POST /featured_comps
  # POST /featured_comps.json
  def create
    @featured_comp = FeaturedComp.new(featured_comp_params)

    respond_to do |format|
      if @featured_comp.save
        @featured_comp.add_featured_building(params[:comparable_building_ids]) if params[:comparable_building_ids].present?
        format.html { redirect_to featured_comps_path, notice: 'Featured comp was successfully created.' }
        format.json { render :show, status: :created, location: @featured_comp }
      else
        format.html { render :new }
        format.json { render json: @featured_comp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /featured_comps/1
  # PATCH/PUT /featured_comps/1.json
  def update
    respond_to do |format|
      if @featured_comp.update(featured_comp_params)
        format.html { redirect_to featured_comps_path, notice: 'Featured comp was successfully updated.' }
        format.json { render :json => { success: true, data: @featured_comp } }
      else
        format.html { render :edit }
        format.json { render json: @featured_comp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /featured_comps/1
  # DELETE /featured_comps/1.json
  def destroy
    @featured_comp.destroy
    respond_to do |format|
      format.html { redirect_to featured_comps_url, notice: 'Featured comp was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_featured_comp
      @featured_comp = FeaturedComp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def featured_comp_params
      params.require(:featured_comp).permit(:building_id, :start_date, :end_date, :active)
    end
end
