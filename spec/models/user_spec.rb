require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  describe "is not saved" do
    it "without a password" do
      user = User.create username: "Pekka"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "with a short password" do
      user = User.create username: "Pekka", password: "qwe"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end

    it "with a password consisting of [a-z] only" do
      user = User.create username: "Pekka", password: "qweadsfdsafwerqwADSF"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  describe "with a proper password" do
    let(:user){ FactoryBot.create(:user) }
    let(:test_brewery) { FactoryBot.create(:brewery) }
    let(:test_beer) { FactoryBot.create :beer, brewery: test_brewery }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }

    it "method can be called" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "returns nil without ratings" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({ user: user }, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }

    it "method can be called" do
      expect(user).to respond_to(:favorite_style)
    end

    it "returns nil without ratings" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({ user: user }, 5, 10, 5, 5)
      create_beers_with_many_ratings({ user: user, style: "IPA" }, 50)
      create_beers_with_many_ratings({ user: user }, 5, 5, 5)

      expect(user.favorite_style).to eq("IPA")
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }

    it "method can be called" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "returns nil without ratings" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the one with highest rating if several rated" do
      brew1 = FactoryBot.create(:brewery)
      brew2 = FactoryBot.create(:brewery)
      brew3 = FactoryBot.create(:brewery)

      create_beers_with_many_ratings({ user: user, brewery: brew1 }, 5, 10, 5, 5)
      create_beers_with_many_ratings({ user: user, brewery: brew2, style: "IPA" }, 50)
      create_beers_with_many_ratings({ user: user, brewery: brew3 }, 5, 5, 5)

      expect(user.favorite_brewery).to eq(brew2)
    end
  end
end

def create_beer_with_rating(object, score)
  beer_opts = {}
  beer_opts[:style] = object[:style] if object[:style]
  beer_opts[:brewery] = object[:brewery] if object[:brewery]

  beer = FactoryBot.create(:beer, **beer_opts)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end
