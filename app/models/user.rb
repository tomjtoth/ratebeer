class User < ApplicationRecord
  validates :username, uniqueness: true, length: { minimum: 3 }
  has_many :ratings
  include RatingAverage
end
