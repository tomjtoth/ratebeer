require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "shows rating number correctly" do
    visit ratings_path
    expect(page).to have_content "There are no ratings, yet..."
    
    FactoryBot.create(:rating, {user: user, beer: beer1, score: 27})
    visit ratings_path
    expect(page).to have_content "There is 1 rating:"
    expect(page).to have_content "#{beer1.name} 27"
    

    FactoryBot.create(:rating, {user: user, beer: beer2, score: 35})
    visit ratings_path
    expect(page).to have_content "There are #{Rating.count} ratings:"
    expect(page).to have_content "#{beer2.name} 35"
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
end