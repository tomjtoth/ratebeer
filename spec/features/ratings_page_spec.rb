require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }
  let(:user2) { FactoryBot.create :user, username: "Maija" }

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

  describe "when given by multiple users" do
    let!(:rating1){ FactoryBot.create(:rating, {user: user, beer: beer1, score: 27})}
    let!(:rating2){ FactoryBot.create(:rating, {user: user2, beer: beer2, score: 35}) }

    it "all show up on the ratings_path" do 
        visit ratings_path
        expect(page).to have_content "#{beer1.name} 27 #{user.username}"
        expect(page).to have_content "#{beer2.name} 35 #{user2.username}"
    end

    it "any user can see only their own ratings on their profile" do
      visit user_path(user)
      expect(page).to have_content "#{beer1.name} 27 Delete"
      expect(page).not_to have_content "#{beer2.name} 35"
      
      visit user_path(user2)
      expect(page).to have_content "#{beer2.name} 35"
      expect(page).not_to have_content "#{beer1.name} 27"
    end

    it "a removed rating is also deleted from DB" do
        rating3 = FactoryBot.create(:rating, {user: user, beer: beer2, score: 3})
        rating4 = FactoryBot.create(:rating, {user: user, beer: beer2, score: 2})
        rating5 = FactoryBot.create(:rating, {user: user, beer: beer2, score: 50})

        visit user_path(user)
        within(:xpath, "//li[contains(text(), '#{rating4.beer.name} #{rating4.score}')]") do
            click_link "Delete"
        end

        expect(Rating.exists?(rating1.id)).to be true
        expect(Rating.exists?(rating2.id)).to be true
        expect(Rating.exists?(rating3.id)).to be true
        expect(Rating.exists?(rating4.id)).to be false
        expect(Rating.exists?(rating5.id)).to be true
    end
  end
end