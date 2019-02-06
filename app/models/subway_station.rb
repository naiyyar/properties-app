class SubwayStation < ActiveRecord::Base
	has_many :subway_station_lines

	include PgSearch
  pg_search_scope :search, against: [:name],
     :using => { :tsearch => { prefix: true }, 
     						 :trigram=> { :threshold => 0.3 }  }

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

	def line_color line
		case line
		when 'A','C','E'
			'#2850ad'
		when 'B', 'D', 'F', 'M'
			'#ff6319'
		when 'G'
			'#6cbe45'
		when 'J', 'Z'
			'#996633'
		when 'L'
			'#a7a9ac'
		when 'N','Q','R','W'
			'#fccc0a'
		when 'S'
			'#808183'
		when '1','2','3'
			'#ee352e'
		when '4','5','6'
			'#00933c'
		when '7'
			'#b933ad'
		end
	end
end
