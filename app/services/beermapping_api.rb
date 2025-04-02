class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 7.days) { get_places_in(city) }
  end

  def self.get_places_in(city)
    # url = "http://beermapping.com/webservice/loccity/#{key}/"
    # url = "https://beermapping-dummy.fly.dev/webservice/loccity/#{key}/"
    url = "https://studies.cs.helsinki.fi/beermapping/locations/"

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
    return nil if Rails.env.test? # testatessa ei apia tarvita, palautetaan nil
    raise 'BEERMAPPING_APIKEY env variable not defined' if ENV['BEERMAPPING_APIKEY'].nil?
    ENV.fetch('BEERMAPPING_APIKEY')
  end
end
