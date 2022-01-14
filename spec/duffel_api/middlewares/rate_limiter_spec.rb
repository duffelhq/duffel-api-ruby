# frozen_string_literal: true

require "spec_helper"
require "date"

describe DuffelAPI::Middlewares::RateLimiter do
  let(:connection) do
    Faraday.new do |faraday|
      faraday.request :rate_limiter
      faraday.adapter :net_http
    end
  end
  let(:body) { nil }
  let(:status) { 200 }

  before do
    stub_request(:post, "https://api.duffel.com/air/airports").
      to_return(status: status, body: body, headers: headers)
  end

  describe "when the rate limit has been exceeded" do
    let(:headers) do
      {
        "Content-Type" => "application/json",
        "RateLimit-Limit" => "50",
        "RateLimit-Remaining" => "0",
        "RateLimit-Reset" => DateTime.now.httpdate,
      }
    end

    it "sleeps for 1 second" do
      expect(Kernel).to receive(:sleep).with(1)
      # NOTE: First call triggers the rate limit
      connection.post("https://api.duffel.com/air/airports")
      connection.post("https://api.duffel.com/air/airports")
    end
  end
end
