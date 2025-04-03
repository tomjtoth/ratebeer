class PlacesController < ApplicationController
  def index
  end

  def show
    city = session[:city]
    id = params.expect(:id)
    @place = Rails.cache.read(city.downcase).find { |c| c.id == id }
  end

  def search
    city = params[:city]
    session[:city] = city
    @places = BeermappingApi.places_in(city)
    @weather = WeatherApi.weather_in(city)
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{city}"
    else
      render :index, status: 418
    end
  end
end
