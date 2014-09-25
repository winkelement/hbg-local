class SearchLocation < ActiveRecord::Base
  # Validations
  validates :query, presence: true, uniqueness: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end
