# frozen_string_literal: true

require "faraday"
require "logger"

module DuffelAPI
  module Middlewares
    class RateLimiter < Faraday::Middleware
      class << self
        attr_accessor :ratelimit_limit, :ratelimit_remaining, :ratelimit_reset

        def mutex
          @mutex ||= Mutex.new
        end
      end

      def initialize(app, options = {})
        super(app, options)
      end

      def call(env)
        sleep_until_ratelimit_reset if rate_limited?

        app.call(env).tap do |response|
          headers = response.env.response_headers

          RateLimiter.mutex.synchronize do
            RateLimiter.ratelimit_limit = new_ratelimit_limit(headers)
            RateLimiter.ratelimit_remaining = new_ratelimit_remaining(headers)
            RateLimiter.ratelimit_reset = new_ratelimit_reset(headers)
          end
        end
      end

      private

      # NOTE: The check for 'ratelimit-limit' vs 'Ratelimit-Limit' is required
      # because RSpec and Rails proper handle HTTP headers differently.
      # WebMock converts the header to the latter style, whereas when running
      # through Rails it will be converted to the former.
      def header_value_with_indifferent_key(headers, key)
        headers.find { |k, _v| k.casecmp(key).zero? }&.at(1)
      end

      def new_ratelimit_limit(headers)
        header_value_with_indifferent_key(headers, "ratelimit-limit")&.to_i
      end

      def new_ratelimit_remaining(headers)
        header_value_with_indifferent_key(headers, "ratelimit-remaining")&.to_i
      end

      def new_ratelimit_reset(headers)
        reset_time = header_value_with_indifferent_key(headers, "ratelimit-reset")
        reset_time.nil? ? nil : DateTime.parse(reset_time).to_time
      end

      def rate_limited?
        return false if RateLimiter.ratelimit_reset.nil?
        return false if RateLimiter.ratelimit_remaining.nil?

        RateLimiter.ratelimit_remaining.zero?
      end

      def sleep_until_ratelimit_reset
        sleep_time = (RateLimiter.ratelimit_reset.to_i - Time.now.to_i) + 1
        return unless sleep_time.positive?

        ::Logger.new($stdout).info(
          "Duffel rate-limit hit. Sleeping for #{sleep_time} seconds",
        )
        Kernel.sleep(sleep_time)
      end
    end
  end
end

Faraday::Request.register_middleware rate_limiter: DuffelAPI::Middlewares::RateLimiter
