require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WeatherService, type: :service do
  describe '#average_temperature' do
    let(:city) { 'London' }
    let(:days) { 3 }

    before do
      stub_request(:get, /geocoding-api.open-meteo.com/)
        .to_return(
          status: 200,
          body: {
            results: [
              { latitude: 51.5074, longitude: -0.1278 }
            ]
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      stub_request(:get, /[^geocoding-]api.open-meteo.com/)
        .to_return(
          status: 200,
          body: {
            daily: {
              temperature_2m_max: [18.0, 19.0, 20.0],
              temperature_2m_min: [10.0, 11.0, 12.0]
            }
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    context 'when the API call is successful' do
      it 'returns the correct average temperature' do
        service = WeatherService.new(city, days)
        result = service.average_temperature
        expect(result).to eq(15.0)
      end

      it 'caches the response in Redis' do
        service = WeatherService.new(city, days)
        service.average_temperature
        cache_key = "weather:#{city.downcase}:#{days}"
        cached_data = $redis.get(cache_key)
        expect(cached_data).not_to be_nil
      end
    end

    context 'when the city name is invalid' do
      it 'returns nil' do
        stub_request(:get, /geocoding-api.open-meteo.com/)
          .to_return(status: 404)

        service = WeatherService.new('InvalidCity', days)
        expect(service.average_temperature[:error]).to eq('City not found')
      end
    end
  end
end
