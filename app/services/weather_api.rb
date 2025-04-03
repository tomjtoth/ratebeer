class WeatherApi
  def self.weather_in(city)
    city = city.downcase
    Rails.cache.fetch("weather:#{city}", expires_in: 5.minutes) { query_server(city) }
  end

  def self.query_server(city)
    url = "https://api.weatherstack.com/current?access_key=#{key}&query="

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"

    err = response.parsed_response["error"]
    return { error: err["info"] } if err

    curr = response.parsed_response["current"]
    icons = curr["weather_icons"]

    {
      city: city.titleize,
      temp: curr["temperature"],
      icon: icons[0],
      speed: curr["wind_speed"],
      dir: curr["wind_dir"]
    }
  end

  def self.key
    return nil if Rails.env.test?
    raise 'WEATHER_APIKEY env variable not defined' if ENV['WEATHER_APIKEY'].nil?
    ENV.fetch('WEATHER_APIKEY')
  end
end
