class Review < ActiveRecord::Base
	resourcify
  belongs_to :reviewable, polymorphic: true
  belongs_to :user
end
