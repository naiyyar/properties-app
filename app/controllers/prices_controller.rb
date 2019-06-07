class PricesController < ApplicationController
  before_action :set_price, only: [:show, :edit, :update, :destroy]

  # GET /prices
  # GET /prices.json
  def index
    @prices = Price.order(:bed_type)
    @price = Price.new
    @fee_percent = BrokerFeePercent.first
  end

  # GET /prices/1
  # GET /prices/1.json
  def show
  end

  # GET /prices/new
  def new
    @price = Price.new
  end

  # GET /prices/1/edit
  def edit
  end

  def add_or_update_prices
    if params[:price].present?
      params[:price].each_pair do |key, value|
        existing_prices = Price.where(bed_type: key, range: params[:range])
        if existing_prices.present?
          obj = existing_prices.first
          obj.update({ min_price: value[:min_price], max_price: value[:max_price] }) 
        else
          Price.create({min_price: value[:min_price], max_price: value[:max_price], bed_type: key, range: params[:range]})
        end
      end
    end

    redirect_to :back
  end

  # POST /prices
  # POST /prices.json
  def create
    # @price = Price.new(price_params)

    respond_to do |format|
      if @price.save
        format.html { redirect_to @price, notice: 'Price was successfully created.' }
        format.json { render :show, status: :created, location: @price }
      else
        format.html { render :new }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prices/1
  # PATCH/PUT /prices/1.json
  def update
    respond_to do |format|
      if @price.update(price_params)
        format.html { redirect_to @price, notice: 'Price was successfully updated.' }
        format.json { render :show, status: :ok, location: @price }
      else
        format.html { render :edit }
        format.json { render json: @price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prices/1
  # DELETE /prices/1.json
  def destroy
    @price.destroy
    respond_to do |format|
      format.html { redirect_to prices_url, notice: 'Price was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_price
      @price = Price.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def price_params
      params.require(:price).permit(:min_price, :max_price, :bed_type)
    end
end
