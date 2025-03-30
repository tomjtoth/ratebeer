class User < ApplicationRecord
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validate :password_is_complex

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_secure_password
  include RatingAverage

  private
    def password_is_complex
      errors.add(:password, "not long enough") if password.length < 4
      errors.add(:password, "must contain at least 1 capital letter") unless password.match(/[A-Z]/)
      errors.add(:password, "must contain at least 1 digit") unless password.match(/[0-9]/)
    end
end
