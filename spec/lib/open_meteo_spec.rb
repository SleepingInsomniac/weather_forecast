require "rails_helper"

RSpec.describe OpenMeteo do
  describe OpenMeteo::V1 do
    describe "::forecast" do
      it "returns the current tempurature for the given coords" do
        latitude, longitude = '52.52', '13.41'
        VCR.use_cassette("open_meteo_v1_#{latitude}_#{longitude}") do
          response = OpenMeteo::V1.forecast(latitude:, longitude:)
          expect(response.dig('current', 'temperature_2m')).to be_a(Numeric)
        end
      end
    end
  end
end
