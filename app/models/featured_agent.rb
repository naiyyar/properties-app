class FeaturedAgent < ApplicationRecord
	include PgSearch::Model
	include ImageableConcern
	include Billable

  extend SplitViewAgentDisplay
  extend RenewPlan

  FEATURING_WEEKS = 'four'

  BEDROOMS = ['Room', 'Studio', '1 Bedroom',  '2 Bedroom',  '3 Bedroom', '4+ Bedroom'].freeze

  BUDGET = [
    '$1,750',
    '$2,000',
    '$2,500',
    '$3,000',
    '$3,500',
    '$4,000',
    '$4,500',
    '$5,000',
    '$6,000',
    '$7,000',
    '$8,000',
    '$9,000',
    '$10,000',
    '$12,500',
    '$15,000'
  ].freeze

  FEATURED_IN_NEIGHBORHOODS = [
    'Lower Manhattan',
    'Midtown Manhattan',
    'Upper East Side',
    'Upper West Side',
    'Upper Manhattan',
    'Brooklyn',
    'Queens',
    'Bronx'
  ].freeze

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
    errors.add :base, 'Cannot delete active featured Agent.'
    false
    throw(:abort)
  end
end
