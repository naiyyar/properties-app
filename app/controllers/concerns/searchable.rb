module Searchable
  extend ActiveSupport::Concern

  private

  def filterrific_search_results other_filter=[]
    available_filters = other_filter + [:search_query]
    @filterrific = initialize_filterrific(
      model_class,
      params[:filterrific],
      available_filters: available_filters
    ) or return
    @filterrific.find.order('created_at desc')
  end
end