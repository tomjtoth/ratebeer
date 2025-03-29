class Beer < ApplicationRecord
    belongs_to :brewery
    has_many :ratings

    def average_rating
        total_score = ratings.reduce(0) { |sum, r| sum + r.score }
        (total_score / ratings.size).to_f
    end

    def to_s
      "#{name} (#{brewery.name})"
    end
end
