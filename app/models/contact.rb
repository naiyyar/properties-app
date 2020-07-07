# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  comment    :text
#  email    	:string
#  phone    	:string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Contact < ApplicationRecord
	belongs_to :building
	after_save :send_emails, on: :create

	
	private
	def send_emails
    if self.building_id.present?
      UserMailer.send_enquiry_to_building(self).deliver
      UserMailer.enquiry_sent_mail_to_sender(self).deliver
    else
      UserMailer.delay.send_feedback(self)
    end
  end
end
