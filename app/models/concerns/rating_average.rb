module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    total_score = ratings.reduce(0) { |sum, r| sum + r.score }
    (total_score / ratings.size).to_f
  end
end
