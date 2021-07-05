class ManagementCompany < ApplicationRecord
	has_many :buildings
	validates :website, :url => true, allow_blank: true

	# pgsearch
	include PgSearch::Model
  pg_search_scope :text_search_by_management_company, against: [:name],
                  :using => { :tsearch => { prefix: true } }

	# methods

	def to_param
    if name.present?
      "#{id} #{name}".parameterize
    end
  end

  def active_email_buildings?
  	company_buildings.with_active_email.present?
  end

  def active_website_buildings?
  	company_buildings.with_active_web.present?
  end

  def apply_link?
    company_buildings.with_application_link.present?
  end

   def company_buildings
    @company_buildings ||= buildings.reorder(neighborhood: :asc, 
                                             building_name: :asc, 
                                             building_street_address: :asc)
  end

  def cached_buildings
    CacheService.new(records: company_buildings, 
                     key: "company_buildings_#{self.id}").fetch
  end

end
