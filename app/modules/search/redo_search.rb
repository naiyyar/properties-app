module Search
	module RedoSearch
		def redo_search_buildings lat, lng, zoom = nil
	    zoom         = zoom.present? ? zoom.to_i : 14
	    custom_latng = [lat.to_f, lng.to_f]
	    distance     = redo_search_distance(0.5, zoom)
	    buildings    = near(custom_latng, distance, units: :km, order: '')
	    distance     = redo_search_distance(1.0, zoom)
	    buildings    = near(custom_latng, distance, units: :km, order: '') if buildings.blank?

	    buildings
	  end

	  def redo_search_distance distance, zoom
	    if zoom >= 14
	      distance = distance / zoom
	      case zoom
	      when 14 then distance += 1.5
	      when 15 then distance += 0.8
	      when 16 then distance += 0.5
	      when 17 then distance += 0.2
	      else
	        distance += 0.1
	      end
	    else
	      case zoom
	      when 13 then distance += 3
	      when 12 then distance += 4
	      when 11 then distance += (zoom * 2)
	      else
	        distance += (zoom * 2.5)
	      end
	    end
	    distance
	  end
	end
end