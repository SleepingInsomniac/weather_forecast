require 'rails_helper'

RSpec.describe "/weather", type: :request do
  describe "GET /show" do
    it "renders a successful response" do
      VCR.use_cassette("weather_49505", match_requests_on: [:method, :path]) do
        get weather_url('49505')
        expect(response).to be_successful
      end
    end
  end

  describe "POST /create" do
    it "Returns search results" do
      VCR.use_cassette("weather_search", match_requests_on: [:method, :path]) do
        post weather_index_url, params: { address: { city: 'New York', state: 'New York' } }
        expect(response).to be_successful
      end
    end
  end
end
