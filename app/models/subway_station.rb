class SubwayStation < ApplicationRecord
	has_many :subway_station_lines

	attr_accessor :address
	include PgSearch
  pg_search_scope :search, against: [:name],
     							:using => { :tsearch => { prefix: true }, 
     						 	:trigram => { :threshold => 0.3 }  }

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

	def line_color line
		case line
		when 'A','C','E' 				then '#2850ad'
		when 'B', 'D', 'F', 'M' then '#ff6319'
		when 'G' 								then '#6cbe45'
		when 'J', 'Z' 					then '#996633'
		when 'L' 								then '#a7a9ac'
		when 'N','Q','R','W' 		then '#fccc0a'
		when 'S' 								then '#808183'
		when '1','2','3' 				then '#ee352e'
		when '4','5','6' 				then '#00933c'
		when '7' 								then '#b933ad'
		else
			'#fff'
		end
	end
	
end
