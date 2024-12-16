require "rails_helper"

RSpec.describe RateLimiter do
  include ActiveSupport::Testing::TimeHelpers

  class DummyApi
    def self.call
    end
  end

  describe "#last_request" do
    it "returns now and 0 if the no calls have been made" do
      limiter = RateLimiter.new('my_api', 1, 60)
      limiter.reset

      freeze_time do
        time, count = limiter.last_request
        expect(time).to eq(Time.zone.now)
        expect(count).to eq(0)
      end
    end

    it "returns the time of the last call, and the number of calls" do
      limiter = RateLimiter.new('my_api', 1, 60)
      limiter.reset

      freeze_time do
        limiter.__send__(:increment_requests)
      end

      travel_to 1.second.from_now do
        timestamp, count = limiter.last_request
        expect(timestamp).not_to eq(Time.zone.now)
        expect(count).to eq(1)
      end
    end
  end

  describe "#elapsed_decrements" do
    it "returns 0 when no calls have been made" do
      limiter = RateLimiter.new('my_api', 1, 60)
      limiter.reset

      expect(limiter.elapsed_decrements).to eq(0)
    end

    it "returns the limit when the interval has elapsed" do
      limiter = RateLimiter.new('my_api', 1, 60)
      limiter.reset

      60.times { limiter.__send__(:increment_requests) }
      travel_to 1.second.from_now do
        expect(limiter.elapsed_decrements).to eq(60)
      end
    end
  end

  describe "#try" do
    it "limits requests to n requests per interval" do
      limiter = RateLimiter.new('my_api', 1, 60)
      limiter.reset
      expect(DummyApi).to receive(:call).exactly(60).times

      freeze_time do
        60.times do
          limiter.try { DummyApi.call }
        end

        expect do
          limiter.try { DummyApi.call }
        end.to raise_error(RateLimiter::Throttled)
      end
    end

    it "allows new requests after the wait period" do
      limiter = RateLimiter.new('my_api', 1, 60)
      limiter.reset
      expect(DummyApi).to receive(:call).exactly(61).times

      freeze_time do
        60.times do
          limiter.try { DummyApi.call }
        end

        expect do
          limiter.try { DummyApi.call }
        end.to raise_error(RateLimiter::Throttled)
      end

      travel_to 1.second.from_now do
        limiter.try { DummyApi.call }
      end
    end
  end
end
