module Searchable
	extend ActiveSupport::Concern

	private

	def filterrific_search_results
    @filterrific = initialize_filterrific(
      model_class,
      params[:filterrific],
      available_filters: [:search_query]
    ) or return
    @filterrific.find
    						.paginate(:page => params[:page], :per_page => 100)
               	.order('created_at desc')

  end
end