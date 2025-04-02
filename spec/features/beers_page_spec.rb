require 'rails_helper'

include Helpers

describe "Beers page" do
  it "can be opened and should be initially empty" do
    visit beers_path
    expect(page).to have_content 'Beers'
    expect(find('div#beers').all('*').empty?).to be true
  end

  describe "adding beers" do
    let!(:user) { FactoryBot.create :user }
    let!(:brew1) { FactoryBot.create :brewery }
    let!(:brew2) { FactoryBot.create :brewery, name: "kotimainein", year: 2005 }
    let!(:style1) { FactoryBot.create :style }
    let!(:ipa) { FactoryBot.create :style, text: "IPA" }

    before :each do
      sign_in username: "Pekka", password: "Foobar1"
    end

    it "via 'New beer' link works" do
      visit beers_path
      click_link "New beer"

      expect(page).to have_content "New beer"
      expect(page).to have_content "Name"
      expect(page).to have_content "Style"
      expect(page).to have_content "Brewery"

      create_beer({ name: 'UUSI KALJA', style: "IPA", brewery: brew2[:name] })

      expect(page).to have_content "Beer was successfully created."
      expect(page).to have_content "UUSI KALJA"
      expect(page).to have_content "Brewery: #{brew2[:name]}"
      expect(Beer.all.count).to eq(1)
    end

    it "fails with empty name" do
      visit new_beer_path

      create_beer({ name: '', style: "IPA", brewery: brew2[:name] })

      expect(page).to have_content "Name is too short (minimum is 1 character)"
      expect(Beer.all.count).to eq(0)
    end
  end
end

def create_beer(obj)
  fill_in('beer_name', with: obj[:name])
  select(obj[:style], from: "beer_style_id") if obj[:style]
  select(obj[:brewery], from: "beer_brewery_id") if obj[:brewery]

  click_button "Create Beer"
end
