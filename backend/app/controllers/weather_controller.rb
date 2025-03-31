class WeatherController < ApplicationController
  def get
    begin
      city = params[:city]
      days = Integer(params[:days])

      weather_service = WeatherService.new(city, days)
      result = weather_service.average_temperature

      if result.is_a?(Hash) && result[:error]
        render json: { error: result[:error] }, status: :unprocessable_entity
      else
        render json: { city: city, average_temperature: result }
      end
    rescue ArgumentError
      render json: { error: 'Number of days selected invalid' }, status: :unprocessable_entity
    end
  end
end