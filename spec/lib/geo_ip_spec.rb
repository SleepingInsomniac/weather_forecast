require "rails_helper"

RSpec.describe GeoIP do
  describe "::info" do
    it "returns details on the provided IP address" do
      ip_address = '204.48.26.195'
      VCR.use_cassette("geoip_#{ip_address}", match_requests_on: [
        :method,
        :path,
        VCR.request_matchers.uri_without_param(:token)
      ]) do
        info = GeoIP.info(ip_address)
        expect(info['postal']).to eq('07047')
      end
    end

    it "raises an error when the request returns a non-200 status" do
      ip_address = "not valid"
      VCR.use_cassette("geoip_#{ip_address}", match_requests_on: [
        :method,
        :path,
        VCR.request_matchers.uri_without_param(:token)
      ]) do
        assert_raises HTTPAPI::ClientError do
          info = GeoIP.info(ip_address)
        end
      end
    end
  end
end
