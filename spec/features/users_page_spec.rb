require 'rails_helper'

describe "User" do
  let!(:user) { FactoryBot.create :user }

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with: 'Brian')
      fill_in('user_password', with: 'Secret55')
      fill_in('user_password_confirmation', with: 'Secret55')

      expect{
        click_button('Create User')
      }.to change{ User.count }.by(1)
    end

    describe "and signed in + rated beers" do
      let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
      let!(:brewery2) { FactoryBot.create :brewery }
      let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery: brewery }
      let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery: brewery2 }
      let!(:rating1) { FactoryBot.create(:rating, { user: user, beer: beer1, score: 27 }) }
      let!(:rating2) { FactoryBot.create(:rating, { user: user, beer: beer2, score: 35 }) }

      before :each do
        sign_in(username: "Pekka", password: "Foobar1")
      end

      it "can see their favorite style and brewery" do
        visit user_path(user)

        expect(page).to have_content "Their favorite style is #{beer2.style.text} and favorite brewery is #{beer2.brewery.name}"
      end
    end
  end
end
