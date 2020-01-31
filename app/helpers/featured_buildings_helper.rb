module FeaturedBuildingsHelper

	def start_date fb
		Time.zone.parse(fb.try(:start_date).to_s)&.strftime('%Y-%m-%d %H:%M')
	end

	def end_date fb
		Time.zone.parse(fb.try(:end_date).to_s)&.strftime('%Y-%m-%d %H:%M')
	end
end
