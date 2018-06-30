class Amenity < ActiveRecord::Base
  belongs_to :amenitable, polymorphic: true
end
