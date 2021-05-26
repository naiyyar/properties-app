class RentMediansController < ApplicationController
  
  def add_or_update_rent_medians
    if params[:price].present?
      params[:price].each_pair do |key, value|
        existing_prices = RentMedian.where(bed_type: key, range: params[:range])
        if existing_prices.present?
          obj = existing_prices.first
          obj.update({ price: value[:rent_price] }) 
        else
          RentMedian.create({price: value[:rent_price], bed_type: key, range: params[:range]})
        end
      end
    end
    redirect_to request.referer
  end

end
