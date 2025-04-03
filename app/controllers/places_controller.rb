class PlacesController < ApplicationController
  def index
  end

  def show
    city = params.expect(:city)
    id = params.expect(:id).to_i
    @place = Rails.cache.read(city)[id-1]
  end

  def search
    city = params[:city]
    @places = BeermappingApi.places_in(city)
    @weather = WeatherApi.weather_in city
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{city}"
    else
      render :index, status: 418
    end
  end
end
