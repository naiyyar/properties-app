class FeaturedAgent < ApplicationRecord
	include PgSearch
	include Imageable
	include Billable

  extend SplitViewAgentDisplay

	belongs_to :user
	has_many   :billings

	scope :active,      -> { where(active: true) }
	scope :inactive,    -> { where(active: false) }
	scope :by_manager,  -> { where(featured_by: 'manager') }

	pg_search_scope :search_query, 
                  against: [:first_name, :last_name, :neighborhood]

  filterrific(
   default_filter_params: { },
   available_filters: [
     :search_query
    ]
  )

  # callbacks
  after_save :make_active, unless: :featured_by_manager?
  before_destroy :check_active_status, unless: Proc.new{ |obj| obj.expired? }

  def full_name
  	"#{first_name} #{last_name}"
  end

  def featured?
    false
  end

  private
  def check_active_status
    errors.add :base, 'Cannot delete unexpired featured Agent.'
    false
    throw(:abort)
  end
end
