# Performs geographical lookups for IP addresses
#
class GeoIP < HTTPAPI
  class << self
    # Get the API response via HTTP, parse and return the info
    # @param ip [String] The IP address to look up
    # @return [Hash] GeoIP information from the API
    def info(ip)
      cache.fetch("GeoIP_#{ip}", expires_in: 12.hours) do
        make_request do
          HTTP.get("http://ipinfo.io/#{ip}/json", params: { token: api_key })
        end.parse
      end
    end

    private

    def api_key = Rails.application.credentials.ipinfo_key
  end
end
