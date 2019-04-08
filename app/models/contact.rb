# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  comment    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Contact < ActiveRecord::Base
	belongs_to :building
end
