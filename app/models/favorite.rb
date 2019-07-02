class Favorite < ApplicationRecord
  belongs_to :favoriter
  belongs_to :favorable
end