# == Schema Information
#
# Table name: document_downloads
#
#  id         :integer          not null, primary key
#  upload_id  :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DocumentDownload < ActiveRecord::Base
	belongs_to :upload
	belongs_to :user

	def total_user_downloads
		DocumentDownload.where(user_id: self.user_id).count
	end
	
end
