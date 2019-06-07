class BrokerFeePercentsController < ApplicationController
  before_action :set_percent, only: [:update]

  def create
    @broker_fee_percent = BrokerFeePercent.new(broker_fee_percent_params)
    respond_to do |format|
      if @broker_fee_percent.save
        format.html { redirect_to :back, notice: 'Fee percent was successfully created.' }
      else
        flash[:error] = @broker_fee_percent.errors.join(',')
        format.html { redirect_to :back }
      end
    end
  end

  def update
    respond_to do |format|
      if @broker_fee_percent.update(broker_fee_percent_params)
        format.html { redirect_to :back, notice: 'Fee percent was successfully updated.' }
      else
        flash[:error] = @broker_fee_percent.errors.join(',')
        format.html { redirect_to :back }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_percent
    @broker_fee_percent = BrokerFeePercent.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def broker_fee_percent_params
    params.require(:broker_fee_percent).permit(:percent_amount)
  end

end
