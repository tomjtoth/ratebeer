require 'rails_helper'

describe "Places" do
  it "shown on page if a single result is returned from API" do
      allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
        [ Place.new(name: "Oljenkorsi", id: 1) ]
      )

      kumpula

      expect(page).to have_content "Oljenkorsi"
    end

  it "shown on page if multiple results is returned from API" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [
        Place.new(name: "Oljenkorsi1", id: 1),
        Place.new(name: "Oljenkorsi2", id: 2),
        Place.new(name: "Oljenkorsi3", id: 3),
        Place.new(name: "Oljenkorsi4", id: 4),
     ]
    )

    kumpula

    expect(page).to have_content "Oljenkorsi1"
    expect(page).to have_content "Oljenkorsi2"
    expect(page).to have_content "Oljenkorsi3"
    expect(page).to have_content "Oljenkorsi4"
  end

  it "shown on page if multiple results is returned from API" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return([])

    kumpula

    expect(page).to have_content "No locations in kumpula"
  end
end


def kumpula
  allow(WeatherApi).to receive(:weather_in).with("kumpula").and_return({
    city: "Kumpula",
    temp: 27,
    icon: "https://picsum.photos/200/300",
    speed: 5.6,
    dir: "SW"
  })

  visit places_path
  fill_in('city', with: 'kumpula')
  click_button "Search"
end
