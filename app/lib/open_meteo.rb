# Free weather api
# @see https://open-meteo.com/en/docs
module OpenMeteo
  BASE_URI = URI("https://api.open-meteo.com")

  class V1 < HTTPAPI
    BASE_URI = URI.join(BASE_URI, 'v1/')

    # Get the weather details for the specified coordinates
    #
    # @param latitude [String]
    # @param longitude [String]
    # @return [Hash] The v1 forecast response
    def self.forecast(latitude:, longitude:)
      cache_key = [latitude, longitude].map { |n| n.to_f.round(2) }.join(",")
      cache.fetch("open_meteo_#{cache_key}", expires_in: 30.minutes) do
        make_request do
          HTTP.get(URI.join(BASE_URI, 'forecast'), params: {
            latitude: latitude,
            longitude: longitude,
            current: ['temperature_2m', 'relative_humidity_2m', 'wind_gusts_10m', 'precipitation'],
            temperature_unit: 'fahrenheit',
            wind_speed_unit: 'mph',
            precipitation_unit: 'inch'
          })
        end.parse.merge({
          'cached_at' => Time.zone.now.iso8601,
          'cache_key' => "open_meteo_#{cache_key}"
        })
      end
    end
  end
end
