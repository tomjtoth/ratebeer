class Rating < ApplicationRecord
  belongs_to :beer
  belongs_to :user

  def to_s
    "tekstiesitys"
  end
end
