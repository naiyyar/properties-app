class DocumentDownload < ActiveRecord::Base
	belongs_to :upload
	belongs_to :user

	def total_user_downloads
		DocumentDownload.where(user_id: self.user_id).count
	end
	
end
