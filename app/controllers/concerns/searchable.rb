module Searchable
  extend ActiveSupport::Concern
  DEFAULT_FILTER = [:search_query]
  
  private

  def filterrific_search_results
    @filterrific = initialize_filterrific(
      model_class,
      params[:filterrific],
      available_filters: extra_filters + DEFAULT_FILTER
    ) or return
    @filterrific.find.order(created_at: :desc)
  end

  def extra_filters
    model_class.name == 'Listing' ? [:default_listing_order] : []
  end
end