class User < ApplicationRecord
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  has_many :ratings
  has_many :beers, through: :ratings
  has_secure_password
  include RatingAverage
end
