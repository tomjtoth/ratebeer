class Brewery < ApplicationRecord
    validates :name, length: { minimum: 1 }
    validates :year, numericality: {
        only_integer: true,
        greater_than_or_equal_to: 1040,
        less_than_or_equal_to: 2022
    }
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
end
