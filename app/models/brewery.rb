class Brewery < ApplicationRecord
    validates :name, length: { minimum: 1 }
    validate :year_between_1040_and_current_year
    
    has_many :beers, dependent: :destroy
    has_many :ratings, through: :beers
    include RatingAverage

    def print_report
        puts name
        puts "established at year #{year}"
        puts "number of beers #{beers.count}"
    end

    def restart
        self.year = 2022
        puts "changed year to #{year}"
    end

    private
        def year_between_1040_and_current_year
            if year > Time.now.year
                errors.add(:year, "can't be in the future")
            elsif year < 1040
                errors.add(:year, "can't be earlier, than 1040")
            end
        end
end
