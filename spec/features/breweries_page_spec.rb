require 'rails_helper'

describe "Breweries page" do
    it "should not have any before been created" do
        visit_n_print breweries_path
        expect(page).to have_content 'Breweries'
        expect(page).to have_content 'Number of breweries: 0'
    end
end

def visit_n_print(path)
    visit path
    puts page.html
end
