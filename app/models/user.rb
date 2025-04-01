class User < ApplicationRecord
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validate :password_is_complex

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
  has_secure_password
  include RatingAverage

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    favorite_by(->(rating) { rating.beer.style })
  end

  def favorite_brewery
    favorite_by(->(rating) { rating.beer.brewery })
  end

  private
    def password_is_complex
      errors.add(:password, "not long enough") if !password or password.length < 4
      errors.add(:password, "must contain at least 1 capital letter") unless password and password.match(/[A-Z]/)
      errors.add(:password, "must contain at least 1 digit") unless password and password.match(/[0-9]/)
    end

    def favorite_by(group_by_closure)
      return nil if ratings.empty?

      scores = ratings
        .group_by { |rating| group_by_closure.call(rating) }
        .transform_values { |ratings| ratings.sum(&:score) }

      scores.max_by { |style, total_score| total_score }&.first
    end
end
