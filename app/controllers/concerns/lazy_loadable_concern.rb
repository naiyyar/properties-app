module LazyLoadableConcern
	extend ActiveSupport::Concern

	included do
    before_action :set_image_counts,    only: [:lazy_load_content, :show ]
    before_action :get_uploads,         only: [:lazy_load_content ]
  end
	
  def lazy_load_content
    respond_to do |format|
      format.js
    end
  end

end