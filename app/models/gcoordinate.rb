class Gcoordinate < ActiveRecord::Base

	def self.neighbohood_boundary_coordinates neighborhoods
		where("neighborhood @@ :q" , q: "%#{neighborhoods}").map{|rec| { lat: rec.latitude, lng: rec.longitude} }
	end
end
