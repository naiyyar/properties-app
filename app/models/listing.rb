class Listing < ApplicationRecord
	include PgSearch
	belongs_to :building

	delegate :management_company, to: :building

	scope :active, -> { where(active: true) }
	scope :inactive, -> { where(active: false) }

  pg_search_scope :search_query, 
  								against: [:id], 
  								associated_against: {
								    building: [:building_name, :building_street_address]
								  }
  default_scope { order(date_active: :desc, management_company: :asc, building_address: :asc, unit: :asc)}
	
	filterrific(
   default_filter_params: { },
   available_filters: [
   		:sorted_by,
     	:search_query
    ]
  )

  after_save :create_unit, unless: :unit_exist?
  after_update :create_unit, unless: :unit_exist?

  def management_company_name
    management_company.try(:name)
  end

  def unit_exist?
  	building.units.where(name: unit).present?
  end
  
  
  private
  def create_unit
  	Unit.create({ name: unit,
  								building_id: building_id,
  								number_of_bedrooms: bed,
									number_of_bathrooms: bath,
									monthly_rent: rent
  							})
  end

end
