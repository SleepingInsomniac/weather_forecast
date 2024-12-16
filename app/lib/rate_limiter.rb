# Rate limit calls over some interval of seconds
# ex:
# ```ruby
# limiter = RateLimiter.new('my_api', 3600, 1000) # 1000 calls per hour
# limiter.try do
#   MyApi.get_resource
# rescue RateLimiter::Throttled => error
#   sleep error.wait # Wait until we can make new requests, or schedule a background job
# end
# ```
class RateLimiter
  class Throttled < StandardError
    attr_reader :wait

    # @param wait [Numeric] The period of time that must elapse befor the next request is allowed.
    def initialize(wait)
      @wait = wait
      super("API Requests throttled, wait #{@wait.to_f.round(3)} seconds")
    end
  end

  PREFIX = 'rate_limit'

  # @param service [String] The identifier for this service
  # @param interval_seconds [Numeric] The time period expressed in seconds
  # @param call_limit [Integer] The number of calls allowed in the time period
  def initialize(service, interval_seconds, call_limit)
    @service, @interval_seconds, @call_limit = service, interval_seconds, call_limit
  end

  # Attempt a call
  # @yield
  # @raise [RateLimiter::Throttled]
  def try
    decrement_requests
    _timestamp, count = last_request
    if @call_limit > count
      yield.tap { increment_requests } # Return the value of the call
    else
      wait = ((count - @call_limit) * calls_per_second).seconds
      raise Throttled.new(wait)
    end
  end

  # Reset the limiter
  def reset = REDIS.hdel(hash_key, "last_request", "call_count")

  # The key used in Redis
  # @return [String]
  def hash_key = "#{PREFIX}:#{@service}"

  # Fetches the last request time and the current request count
  # @return [Array<Time, Integer>]
  def last_request
    timestamp, call_count = REDIS.hmget(hash_key, "last_request", "call_count")
    if timestamp && call_count
      [Time.zone.iso8601(timestamp), call_count.to_i]
    else
      [Time.zone.now, 0]
    end
  end

  # @return [Integer] the number of requests that should be forgotten (no longer count against the limit)
  def elapsed_decrements
    timestamp, count = last_request
    delta_time = Time.zone.now - timestamp
    return 0 if delta_time == 0 # Avoid unlikely divide by zero
    (delta_time / calls_per_second).to_i
  end

  private

  def increment_requests
    REDIS.hset(hash_key, "last_request", Time.zone.now.iso8601)
    REDIS.hincrby(hash_key, "call_count", 1)
  end

  def decrement_requests
    call_count = REDIS.hget(hash_key, "call_count").to_i
    REDIS.hset(hash_key, "call_count", (call_count - elapsed_decrements).clamp(0..))
  end

  def calls_per_second = @interval_seconds.to_f / @call_limit
end
