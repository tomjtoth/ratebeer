require 'rails_helper'

ZERO = "<?xml version='1.0' encoding='utf-8' ?><bmp_locations/>"

ONE = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
END_OF_STRING

THREE = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations>
<location><id>18856</id><name>fake1</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location>
<location><id>18856</id><name>fake2</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location>
<location><id>18856</id><name>fake3</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
END_OF_STRING

def mock_get(str)
  stub_request(:get, /.*turku/).to_return(body: str, headers: { 'Content-Type' => "text/xml" })
end

describe "BeermappingApi" do
  describe "when 1st response is cached" do
    it "getting ONE result gets stored in cache" do
      Rails.cache.clear
      mock_get ONE
      places = BeermappingApi.places_in("turku")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end

    it "no request is made, the 1st response is served from cache" do
      mock_get ZERO
      places = BeermappingApi.places_in("turku")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end

    it "When HTTP GET returns multiple entries, it is parsed and returned" do
      mock_get THREE
      places = BeermappingApi.places_in("turku")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end
  end

  describe "via cache miss" do
    before :each do
      Rails.cache.clear
    end

    it "When HTTP GET returns one entry, it is parsed and returned" do
      mock_get ONE
      places = BeermappingApi.places_in("turku")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end

    it "When HTTP GET returns zero entries, and empty array is returned" do
      mock_get ZERO
      places = BeermappingApi.places_in("turku")

      expect(places.size).to eq(0)
    end

    it "When HTTP GET returns multiple entries, it is parsed and returned" do
      mock_get THREE
      places = BeermappingApi.places_in("turku")

      expect(places.size).to eq(3)
      expect(places[0].name).to eq("fake1")
      expect(places[1].name).to eq("fake2")
      expect(places[2].name).to eq("fake3")
    end
  end
end
