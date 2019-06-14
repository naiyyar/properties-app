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

class Gcoordinate < ActiveRecord::Base

	def self.neighbohood_boundary_coordinates neighborhoods
		nb_coords = where("neighborhood = ?", neighborhoods)
		nb_coords = where("neighborhood @@ :q", q: "%#{neighborhoods}") if nb_coords.blank?
		
		nb_coords.map{|rec| { lat: rec.latitude, lng: rec.longitude} }
	end

end
