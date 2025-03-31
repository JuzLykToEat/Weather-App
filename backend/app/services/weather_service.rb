require 'httparty'

class WeatherService
  include HTTParty
  base_uri ENV.fetch('WEATHER_GEOCODING_URL', 'https://geocoding-api.open-meteo.com/v1/search')

  def initialize(city, days)
    @city = city.downcase.strip
    @days = days.to_i
  end

  def average_temperature
    cache_key = "weather:#{@city}:#{@days}"

    # Check if the result is already cached
    cached_result = $redis.get(cache_key)
    return JSON.parse(cached_result) if cached_result

    coordinates = geocode_city
    return { error: 'City not found' } unless coordinates

    average_temp = fetch_average_temperature(coordinates[:latitude], coordinates[:longitude])

    # Cache the result with a 1-hour expiration
    $redis.setex(cache_key, 1.hour.to_i, average_temp.to_json) if average_temp
    average_temp
  end

  private

  def geocode_city
    response = self.class.get('', query: { name: @city, count: 1 })
    return nil unless response.success?

    location = response.parsed_response['results']&.first
    return nil unless location

    { latitude: location['latitude'], longitude: location['longitude'] }
  end

  def fetch_average_temperature(latitude, longitude)
    start_date = Date.today
    end_date = start_date + @days

    query_url = ENV.fetch('WEATHER_QUERY_URL', 'https://api.open-meteo.com/v1/forecast')
    weather_response = HTTParty.get(query_url, query: {
      latitude: latitude,
      longitude: longitude,
      start_date: start_date,
      end_date: end_date,
      daily: 'temperature_2m_max,temperature_2m_min',
      timezone: 'auto'
    })

    return nil unless weather_response.success?

    daily_data = weather_response.parsed_response['daily']
    temperatures = daily_data['temperature_2m_max'].zip(daily_data['temperature_2m_min']).map do |max, min|
      (max + min) / 2.0
    end

    (temperatures.sum / temperatures.size).round(2)
  end
end
