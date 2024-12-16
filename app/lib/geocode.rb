# Free geocoding api
# @see https://geocode.maps.co
class Geocode < HTTPAPI
  BASE_URI = URI("https://geocode.maps.co/")

  class << self
    def zip(result)
      result['display_name'].split(/\s*,\s*/).find { |part| part =~ /\A\d{5}\z/ }
    end

    # Search for the lat and lon values of a given zip code by country
    # @return [Hash] the a hash containing the lat and lon values for the provided address
    def search(street: nil, city: nil, state: nil, postalcode: nil, country: nil)
      cache_key = [street, city, state, postalcode, country].compact.join(',')
      cache.fetch("geocode_#{cache_key}", expires_in: 30.minutes) do
        # The API requires that we don't make more than 2 requests per second
        RateLimiter.new('geocode_api', 1, 2).try do
          make_request do
            HTTP.get(URI.join(BASE_URI, 'search'), params: {
              street:,
              city:,
              state:,
              postalcode:,
              country:,
              api_key:
            }.compact)
          end.parse
        end
      end
    end

    private

    def api_key = Rails.application.credentials.geocode_key
  end
end
