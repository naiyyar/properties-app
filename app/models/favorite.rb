class Favorite < ApplicationRecord
  belongs_to :favoriter, optional: true
  belongs_to :favorable, optional: true
end