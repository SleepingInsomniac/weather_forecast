# Abstracts requests to HTTP APIs handling error cases.
# Usage:
#   class MyApi < HTTPAPI
#     def self.my_method
#       make_request { HTTP.get('http://example.com') } # Handles errors
#     end
#   end
class HTTPAPI
  class Error < StandardError
    def initialize(response)
      super("HTTP API Error: #{response.request.verb} #{response.request.uri}: #{response.status}")
    end
  end

  # Represents 4xx errors
  class ClientError < Error
  end

  # Represents 5xx errors
  class ServerError < Error
  end

  # Handles errors from the yielded *HTTP::Response* object.
  def self.make_request
    response = yield

    case response.status
    when 400..499 then raise ClientError.new(response)
    when 500..599 then raise ServerError.new(response)
    else
      response
    end
  end

    # Class level cache reader, shared among all instances
  def self.cache = @cache ||= ActiveSupport::Cache::MemoryStore.new
end
