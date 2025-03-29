class User < ApplicationRecord
  has_many :ratings
  include RatingAverage
end
