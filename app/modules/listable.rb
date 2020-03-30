module Listable
	EXPORT_SHEET_HEADER_ROW = ['Date active','Building address','Unit','Rent','Bed','Bath','Months Free',
                             'Owner Paid','Rent Stabilized','Zip Code','Building Price Range','Neighborhood',
                             'Parent Neighborhood', 'Neighborhood3', 'Property Manager','Number of Floors',
                             'Number of Units','Year Built','Active','Amenities']

  def management_company_name
    management_company.try(:name)
  end

  def unit_exist?
    building.units.where(name: unit).present?
  end

  def rentstabilize
    rent_stabilize.present? ? (['t', 'true'].include?(rent_stabilize) ? 'Y' : 'N') : ''
  end
end