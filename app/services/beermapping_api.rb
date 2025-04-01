class BeermappingApi
  def self.places_in(city)
    # url = "http://beermapping.com/webservice/loccity/#{key}/"
    url = "http://localhost:55581/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"

    # I have no access to the original API, only guessing here...
    bmp_locations = response.parsed_response["bmp_locations"]
    return [] if bmp_locations.nil? || bmp_locations.empty?

    places = bmp_locations["location"]

    return [] if places.nil? || places.is_a?(Hash) and places['id'].nil?

    places = [ places ] if places.is_a?(Hash)
    places.map do | place |
      Place.new(place)
    end
  end

  def self.key
    "someHexaHash"
  end
end
