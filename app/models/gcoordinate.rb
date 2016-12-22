class Gcoordinate < ActiveRecord::Base

	def self.neighbohood_boundary_coordinates neighborhoods
		neighborhood_coords = self.where("neighborhood = ?", neighborhoods)
		if neighborhood_coords.blank?
			neighborhood_coords = self.where("neighborhood @@ :q", q: "%#{neighborhoods}")
		end
		return neighborhood_coords.map{|rec| { lat: rec.latitude, lng: rec.longitude} }
	end
end
