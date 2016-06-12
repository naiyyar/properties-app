class Review < ActiveRecord::Base
 belongs_to :imageable, polymorphic: true
 belongs_to :user
end
