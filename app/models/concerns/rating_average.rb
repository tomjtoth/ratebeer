module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    total_score = ratings.reduce(0) { |sum, r| sum + r.score }
    total_score.to_f / ratings.size
  end
end
