# == Schema Information
#
# Table name: gcoordinates
#
#  id           :integer          not null, primary key
#  latitude     :float
#  longitude    :float
#  zipcode      :string
#  state        :string
#  city         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  neighborhood :string
#

class Gcoordinate < ApplicationRecord

	def self.neighbohood_boundary_coordinates neighborhoods
		coords = where(neighborhood: neighborhoods)
		coords = where("neighborhood @@ :q", q: "%#{neighborhoods}") if coords.blank?
		coords.as_json(only: [:latitude, :longitude])
	end

	def self.zip_boundary_coordinates zipcode
		where(zipcode: zipcode).as_json(only: [:latitude, :longitude])
	end

	def as_json(options = {})
    h = super(options)
    h[:lat] = latitude
    h[:lng] = longitude
    h
  end

end
