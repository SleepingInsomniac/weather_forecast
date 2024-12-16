class ApplicationController < ActionController::Base
  rescue_from HTTPAPI::ServerError do
    render text: 'An external API return an error, please try again in a moment', status: :service_unavailable
  end

  rescue_from RateLimiter::Throttled do |error|
    render text: "Too many requests, please wait #{error.wait} seconds", status: :service_unavailable
  end
end
