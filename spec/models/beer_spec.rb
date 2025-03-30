require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:test_brewery) { Brewery.create name: "test", year: 2000 }

  describe "can be created" do
    it "with proper: name, year, brewery_id" do
      beer = Beer.create name: "proper", style: "some style", brewery: test_brewery
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end
  end

  describe "can *NOT* be created" do
    it "without a name" do
      beer = Beer.create style: "some style", brewery: test_brewery
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "without style" do
      beer = Beer.create name: "proper", brewery: test_brewery
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "without assigning a brewery" do
      beer = Beer.create name: "proper", style: "some style"
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "with non-existent brewery" do
      beer = Beer.create name: "proper", style: "some style", brewery_id: test_brewery.id+1
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end
end
