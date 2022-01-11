# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::APIService do
  subject(:service) do
    described_class.new("https://api.duffel.com", "secret_token", **options)
  end

  let(:options) { { default_headers: { "User-Agent" => "evil robot" } } }

  let(:response) do
    {
      status: response_status,
      body: response_body,
      headers: { "Content-Type" => "application/json" },
    }
  end

  let(:response_status) { 200 }
  let(:response_body) { "" }

  it "sends a correctly formatted Authorization header with the access token" do
    stub = stub_request(:get, "https://api.duffel.com/air/offers").
      with(headers: { "Authorization" => "Bearer secret_token" }).
      to_return(response)

    service.make_request(:get, "/air/offers")
    expect(stub).to have_been_requested
  end

  describe "making a GET request without any parameters" do
    it "makes a simple request without parameters" do
      stub = stub_request(:get, "https://api.duffel.com/air/offers").
        to_return(response)

      service.make_request(:get, "/air/offers")
      expect(stub).to have_been_requested
    end
  end

  describe "making a GET request with query parameters" do
    it "correctly passes the query parameters" do
      stub = stub_request(:get, "https://api.duffel.com/air/offers").
        with(query: { "a" => 1, "b" => 2 }).
        to_return(response)

      service.make_request(:get, "/air/offers", params: { a: 1, b: 2 })
      expect(stub).to have_been_requested
    end
  end

  describe "making a POST request with some data" do
    it "passes the data in the body" do
      stub = stub_request(:post, "https://api.duffel.com/air/offer_requests").
        with(body: { cabin_class: "economy" }).
        to_return(response)

      service.make_request(:post, "/air/offer_requests", params: {
        cabin_class: "economy",
      })
      expect(stub).to have_been_requested
    end
  end

  describe "receiving a validation error" do
    let(:response_body) { load_fixture("validation_error.json") }
    let(:response_status) { 422 }

    it "raises a ValidationError exception" do
      stub_request(:post, "https://api.duffel.com/air/offer_requests").
        with(body: { cabin_class: "economy" }).
        to_return(response)

      expect do
        service.make_request(:post, "/air/offer_requests", params: {
          cabin_class: "economy",
        })
      end.to raise_error(DuffelAPI::Errors::ValidationError)
    end
  end

  describe "receiving an authentication error" do
    let(:response_body) { load_fixture("authentication_error.json") }
    let(:response_status) { 401 }

    it "raises an AuthenticationError exception" do
      stub_request(:post, "https://api.duffel.com/air/offer_requests").
        with(body: { cabin_class: "economy" }).
        to_return(response)

      expect do
        service.make_request(:post, "/air/offer_requests", params: {
          cabin_class: "economy",
        })
      end.to raise_error(DuffelAPI::Errors::AuthenticationError)
    end
  end

  describe "receiving an invalid request error" do
    let(:response_body) { load_fixture("invalid_request_error.json") }
    let(:response_status) { 401 }

    it "raises an InvalidRequestError exception" do
      stub_request(:post, "https://api.duffel.com/air/offer_requests").
        with(body: { cabin_class: "economy" }).
        to_return(response)

      expect do
        service.make_request(:post, "/air/offer_requests", params: {
          cabin_class: "economy",
        })
      end.to raise_error(DuffelAPI::Errors::InvalidRequestError)
    end
  end

  describe "receiving an API error" do
    let(:response_body) { load_fixture("api_error.json") }
    let(:response_status) { 400 }

    it "raises an InvalidRequestError exception" do
      stub_request(:post, "https://api.duffel.com/air/offer_requests").
        with(body: { cabin_class: "economy" }).
        to_return(response)

      expect do
        service.make_request(:post, "/air/offer_requests", params: {
          cabin_class: "economy",
        })
      end.to raise_error(DuffelAPI::Errors::APIError)
    end
  end

  describe "receiving an invalid state error" do
    let(:response_body) { load_fixture("invalid_state_error.json") }
    let(:response_status) { 400 }

    it "raises an InvalidRequestError exception" do
      stub_request(:post, "https://api.duffel.com/air/offer_requests").
        with(body: { cabin_class: "economy" }).
        to_return(response)

      expect do
        service.make_request(:post, "/air/offer_requests", params: {
          cabin_class: "economy",
        })
      end.to raise_error(DuffelAPI::Errors::InvalidStateError)
    end
  end

  describe "receiving an airline error" do
    let(:response_body) { load_fixture("airline_error.json") }
    let(:response_status) { 400 }

    it "raises an InvalidRequestError exception" do
      stub_request(:post, "https://api.duffel.com/air/offer_requests").
        with(body: { cabin_class: "economy" }).
        to_return(response)

      expect do
        service.make_request(:post, "/air/offer_requests", params: {
          cabin_class: "economy",
        })
      end.to raise_error(DuffelAPI::Errors::AirlineError)
    end
  end

  describe "receiving a rate limit error" do
    let(:response_body) { load_fixture("rate_limit_error.json") }
    let(:response_status) { 400 }

    it "raises an InvalidRequestError exception" do
      stub_request(:post, "https://api.duffel.com/air/offer_requests").
        with(body: { cabin_class: "economy" }).
        to_return(response)

      expect do
        service.make_request(:post, "/air/offer_requests", params: {
          cabin_class: "economy",
        })
      end.to raise_error(DuffelAPI::Errors::RateLimitError)
    end
  end
end
