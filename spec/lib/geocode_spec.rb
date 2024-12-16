require "rails_helper"

RSpec.describe Geocode do
  describe "::search" do
    it "returns lat and lon for a given zip" do
      postalcode = '95014'
      VCR.use_cassette("geocode_#{postalcode}", match_requests_on: [
        :method,
        :path,
        VCR.request_matchers.uri_without_param(:api_key)
      ]) do
        response = Geocode.search(postalcode:, country: 'US')
        expect(response.first['lat']).to eq('37.3230283830292')
        expect(response.first['lon']).to eq('-122.0214074981752')
      end
    end
  end
end
