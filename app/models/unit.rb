# == Schema Information
#
# Table name: units
#
#  id                      :integer          not null, primary key
#  building_id             :integer
#  name                    :string
#  pros                    :text
#  cons                    :text
#  number_of_bedrooms      :integer
#  number_of_bathrooms     :decimal(, )      default(0.0)
#  monthly_rent            :decimal(, )      default(0.0)
#  square_feet             :decimal(, )      default(0.0)
#  total_upfront_cost      :decimal(, )      default(0.0)
#  rent_start_date         :date
#  rent_end_date           :date
#  security_deposit        :decimal(, )      default(0.0)
#  broker_fee              :decimal(, )      default(0.0)
#  move_in_fee             :decimal(, )      default(0.0)
#  rent_upfront_cost       :decimal(, )      default(0.0)
#  processing_fee          :decimal(, )      default(0.0)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  balcony                 :boolean          default(FALSE)
#  board_approval_required :boolean          default(FALSE)
#  converted_unit          :boolean          default(FALSE)
#  courtyard               :boolean          default(FALSE)
#  dishwasher              :boolean          default(FALSE)
#  fireplace               :boolean          default(FALSE)
#  furnished               :boolean          default(FALSE)
#  guarantors_accepted     :boolean          default(FALSE)
#  loft                    :boolean          default(FALSE)
#  management_company_run  :boolean          default(FALSE)
#  rent_controlled         :boolean          default(FALSE)
#  private_landlord        :boolean          default(FALSE)
#  storage_available       :boolean          default(FALSE)
#  sublet                  :boolean          default(FALSE)
#  terrace                 :boolean          default(FALSE)
#  can_be_converted        :boolean          default(FALSE)
#  dryer_in_unit           :boolean          default(FALSE)
#  user_id                 :integer
#

class Unit < ApplicationRecord
  acts_as_voteable

  include PgSearch
  include Imageable
  include Voteable
  
  attr_accessor :recommended_percent, :reviews_count
  
  ratyrate_rateable 'unit','cleanliness','noise','safe','health','responsiveness','management'
  resourcify
  validates_uniqueness_of :name, scope: [:id, :building_id], presence: true
  
  belongs_to :building
  has_many :reviews, as: :reviewable
  has_many :rental_price_histories, dependent: :destroy
  belongs_to :user

  pg_search_scope :search_query, 
                  against: [:name],
                  :using => {  :tsearch => { prefix: true }, :trigram=> { :threshold => 0.2 } },
                  associated_against: {
                    building: [:building_street_address]
                  }

  filterrific(
   default_filter_params: { },
   available_filters: [
     :search_query
    ]
  )

  default_scope { order('updated_at desc') }

  def to_param
    if name.present?
      "#{id} #{name}".parameterize.upcase
    end
  end 

  def self.search(term)
    if term
      self.where('name ILIKE ?', "%#{term}%")
    else
      self.all
    end
  end

  def bedrooms
    if number_of_bedrooms == 0
      'Studio'
    elsif number_of_bedrooms == 4
      '4+ Bedrooms'
    else
      "#{number_of_bedrooms} Bedrooms"
    end
  end

end
