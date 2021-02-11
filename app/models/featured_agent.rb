class FeaturedAgent < ApplicationRecord
	include PgSearch::Model
	include ImageableConcern
	include Billable

  extend SplitViewFeaturedCard
  extend RenewPlan

  FEATURING_WEEKS = 'four'
  # validations
  FIELDS_TO_VALIDATES = [ :first_name,
                          :last_name,
                          :email,
                          :broker_firm,
                          :license_number,
                          :neighborhood
                        ]

	belongs_to :user
	has_many   :billings

  # validations
  FIELDS_TO_VALIDATES.each do |field|
    validates field, presence: true
  end

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
    errors.add :base, 'Cannot delete active featured Agent.'
    false
    throw(:abort)
  end
end
