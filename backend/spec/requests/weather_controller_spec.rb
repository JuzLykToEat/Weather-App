require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'Weather API', type: :request do
  describe 'GET /weather/:city/:days' do
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

    context 'with valid city and days' do
      it 'returns the average temperature' do
        get "/weather/#{city}/#{days}"
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['city']).to eq(city)
        expect(json['average_temperature']).to eq(15.0)
      end
    end

    context 'with invalid city' do
      it 'returns an error message' do
        stub_request(:get, /geocoding-api.open-meteo.com/)
          .to_return(status: 404)

        get "/weather/InvalidCity/#{days}"
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('City not found')
      end
    end

    context 'with non-integer days' do
      it 'returns a bad request status' do
        get "/weather/#{city}/abc"
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
