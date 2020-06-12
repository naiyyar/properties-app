class FeaturedAgent < ApplicationRecord
	include PgSearch
	include Imageable
	include Billable

	belongs_to :user
	has_many   :billings

	scope :active,      -> { where(active: true) }
	scope :inactive,    -> { where(active: false) }
	scope :by_manager,  -> { where(featured_by: 'manager') }

	pg_search_scope :search_query, 
                  against: [:id], 
                  associated_against: {
                    building: [:first_name, :neighborhood]
                  }

  filterrific(
   default_filter_params: { },
   available_filters: [
     :search_query
    ]
  )

  def full_name
  	"#{first_name} #{last_name}"
  end

  def featured_by_manager?
    featured_by == 'manager'
  end
end
