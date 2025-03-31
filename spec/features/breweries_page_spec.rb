require 'rails_helper'

describe "Breweries page" do
    it "should not have any before been created" do
        visit_n_print breweries_path
        expect(page).to have_content 'Breweries'
        expect(page).to have_content 'Number of breweries: 0'
    end

    it "lists the existing breweries and their total number" do
        breweries = ["Koff", "Karjala", "Schlenkerla"]
        breweries.each do |brewery_name|
            FactoryBot.create(:brewery, name: brewery_name)
        end

        visit_n_print breweries_path

        expect(page).to have_content "Number of breweries: #{breweries.count}"

        breweries.each do |brewery_name|
            expect(page).to have_content brewery_name
        end
    end
end

def visit_n_print(path)
    visit path
    puts page.html
end
