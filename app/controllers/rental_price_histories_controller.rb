class RentalPriceHistoriesController < ApplicationController
  before_action :set_rental_price_history, only: [:show, :edit, :update, :destroy]

  # GET /rental_price_histories
  # GET /rental_price_histories.json
  def index
    @unit = Unit.find(params[:unit_id])
    @unit_rental_price_histories = @unit.rental_price_histories.order('created_at desc')
    @rental_price_histories = RentalPriceHistory.all
  end

  # GET /rental_price_histories/1
  # GET /rental_price_histories/1.json
  def show
  end

  # GET /rental_price_histories/new
  def new
    @unit = Unit.find(params[:unit_id])
    @rental_price_history = RentalPriceHistory.new
  end

  # GET /rental_price_histories/1/edit
  def edit
  end

  # POST /rental_price_histories
  # POST /rental_price_histories.json
  def create
    @rental_price_history = RentalPriceHistory.new(rental_price_history_params)

    respond_to do |format|
      if @rental_price_history.save
        session[:after_contribute] = params[:contribution] if params[:contribution].present?
        format.html { redirect_to unit_path(@rental_price_history.unit), notice: 'Rental price history was successfully created.' }
        format.json { render :show, status: :created, location: @rental_price_history }
      else
        format.html { render :new }
        format.json { render json: @rental_price_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rental_price_histories/1
  # PATCH/PUT /rental_price_histories/1.json
  def update
    respond_to do |format|
      if @rental_price_history.update(rental_price_history_params)
        session[:after_contribute] = params[:contribution] if params[:contribution].present?
        format.html { redirect_to unit_path(@rental_price_history.unit), notice: 'Rental price history was successfully updated.' }
        format.json { render :show, status: :ok, location: @rental_price_history }
      else
        format.html { render :edit }
        format.json { render json: @rental_price_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rental_price_histories/1
  # DELETE /rental_price_histories/1.json
  def destroy
    @rental_price_history.destroy
    respond_to do |format|
      format.html { redirect_to rental_price_histories_url, notice: 'Rental price history was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rental_price_history
      @rental_price_history = RentalPriceHistory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rental_price_history_params
      params.require(:rental_price_history).permit(:residence_start_date,:residence_end_date,:monthly_rent,:broker_fee,:non_refundable_costs,:rent_upfront,:refundable_deposits,:unit_id)
    end
end
