module ListingsActionConcern
	extend ActiveSupport::Concern

  included do
    load_and_authorize_resource only: [:index, :export]
    before_action :set_building, only: :show_more
    before_action :find_listings_between_dates,  only: [:export, :transfer]
  end

	def index
    @listings = filterrific_search_results([:default_listing_order]).paginate(:page => params[:page], :per_page => 100)
                                          .includes(building: [:management_company])
                                          .default_listing_order
    # @filterrific = initialize_filterrific(
    #     model_class,
    #     params[:filterrific],
    #     available_filters: [:default_listing_order, :search_query]
    #   ) or return
    #   @listings = @filterrific.find.paginate(:page => params[:page], :per_page => 100)
    #                                .includes(building: [:management_company])
    #                                .default_listing_order

    unless model_class.to_s == 'Listing'
      @type = 'past'
      @export_listings_path = export_past_listings_path
    else
      @type = 'current'
      @export_listings_path = export_listings_path
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show_more
    @rentals  = params[:listing_type] || 'active'
    @listings = @building.get_listings(params[:filter_params], @rentals)
    @listings_count = if @rentals == 'past' 
                        @building.past_listings.count
                      else
                        @listings.size
                      end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def export
    case params[:format]
      when 'xls'  then render xls:  'export'
      when 'xlsx' then render xlsx: 'export', filename: exported_file_name
      when 'csv'  then render csv:  'export'
      else render action: 'index'
    end
  end

  private

  def set_building
    @building = Building.find(params[:building_id])
  end

  def find_listings_between_dates
    @listings = model_class.between(from_date, to_date)
  end

  def to_date
    params[:date_to].present? ? Date.parse(params[:date_to]) : (from_date + 1.month)
  end

  def from_date
    Date.parse(params[:date_from])
  end

  def exported_file_name
    "#{model_class}_#{params[:date_from]}_to_#{params[:date_to]}.#{params[:format]}"
  end

end