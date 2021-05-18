class CacheService
	
	def initialize records:, key:
		@records = records
		@key = key
	end

	def fetch
    Rails.cache.fetch(@key) { @records }
	end

end