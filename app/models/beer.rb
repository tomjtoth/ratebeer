class Beer < ApplicationRecord
  validates :name, length: { minimum: 1 }
  validates :style, length: { minimum: 1 }
  validate :assigned_brewery_exists

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user
  include RatingAverage

  def to_s
    "#{name} (#{brewery.name})"
  end

  def average
    return 0 if ratings.empty?

    ratings.map { |r| r.score }.sum / ratings.count.to_f
  end

  private
    def assigned_brewery_exists
      errors.add(:brewery, "does not exist") if not (
        brewery and
        brewery.id and
        Brewery.find(brewery.id)
      )
    end
end
