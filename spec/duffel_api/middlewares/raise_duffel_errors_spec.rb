# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Middlewares::RaiseDuffelErrors do
  let(:connection) do
    Faraday.new do |faraday|
      faraday.response :raise_duffel_errors
      faraday.adapter :net_http
    end
  end
  let(:body) { nil }
  let(:headers) { { "Content-Type" => "application/json" } }

  before do
    stub_request(:post, "https://api.duffel.com/air/airports").to_return(status: status,
                                                                         body: body,
                                                                         headers: headers)
  end

  context "with a non-JSON response" do
    let(:body) { load_fixture("error.html") }
    let(:headers) { { "Content-Type" => "text/html" } }
    let(:status) { 514 }

    it "raises an error" do
      expect { connection.post("https://api.duffel.com/air/airports") }.
        to raise_error(DuffelAPI::Errors::Error)
    end

    it "exposes the API response on the error" do
      connection.post("https://api.duffel.com/air/airports")
    rescue DuffelAPI::Errors::Error => e
      expect(e.api_response).to be_a(DuffelAPI::APIResponse)

      expect(e.api_response.headers).to eq({ "content-type" => "text/html" })
      expect(e.api_response.body).to eq(body)
      expect(e.api_response.status_code).to eq(514)
    end
  end

  context "with a 5XX response that is still JSON" do
    let(:status) { 503 }
    let(:body) { { available: false }.to_json }

    it "raises an error" do
      expect { connection.post("https://api.duffel.com/air/airports") }.
        to raise_error(DuffelAPI::Errors::Error)
    end

    it "exposes the API response on the error" do
      connection.post("https://api.duffel.com/air/airports")
    rescue DuffelAPI::Errors::Error => e
      expect(e.api_response).to be_a(DuffelAPI::APIResponse)

      expect(e.api_response.headers).to eq({ "content-type" => "application/json" })
      expect(e.api_response.body).to eq(body)
      expect(e.api_response.status_code).to eq(503)
    end
  end

  context "with a 2XX response" do
    let(:status) { 200 }

    it "doesn't raise an error" do
      expect { connection.post("https://api.duffel.com/air/airports") }.
        to_not raise_error
    end
  end

  context "with a 4XX response" do
    context "for an invalid request error" do
      let(:status) { 400 }
      let(:body) { load_fixture("invalid_request_error.json") }

      it "raises an InvalidRequestError" do
        expect { connection.post("https://api.duffel.com/air/airports") }.
          to raise_error(DuffelAPI::Errors::InvalidRequestError)
      end

      it "exposes the API response on the error" do
        connection.post("https://api.duffel.com/air/airports")
      rescue DuffelAPI::Errors::Error => e
        expect(e.api_response).to be_a(DuffelAPI::APIResponse)

        expect(e.api_response.headers).to eq({ "content-type" => "application/json" })
        expect(e.api_response.body).to eq(body)
        expect(e.api_response.status_code).to eq(400)
      end
    end

    context "for an authentication error" do
      let(:status) { 401 }
      let(:body) { load_fixture("authentication_error.json") }

      it "raises an InvalidRequestError" do
        expect { connection.post("https://api.duffel.com/air/airports") }.
          to raise_error(DuffelAPI::Errors::AuthenticationError)
      end
    end

    context "for an invalid state error" do
      let(:status) { 401 }
      let(:body) { load_fixture("invalid_state_error.json") }

      it "raises an InvalidRequestError" do
        expect { connection.post("https://api.duffel.com/air/airports") }.
          to raise_error(DuffelAPI::Errors::InvalidStateError)
      end
    end

    context "for an airline error" do
      let(:status) { 401 }
      let(:body) { load_fixture("airline_error.json") }

      it "raises an InvalidRequestError" do
        expect { connection.post("https://api.duffel.com/air/airports") }.
          to raise_error(DuffelAPI::Errors::AirlineError)
      end
    end

    context "for a rate limit error" do
      let(:status) { 401 }
      let(:body) { load_fixture("rate_limit_error.json") }

      it "raises an InvalidRequestError" do
        expect { connection.post("https://api.duffel.com/air/airports") }.
          to raise_error(DuffelAPI::Errors::RateLimitError)
      end
    end

    context "for a validation error" do
      let(:status) { 401 }
      let(:body) { load_fixture("validation_error.json") }

      it "raises an InvalidRequestError" do
        expect { connection.post("https://api.duffel.com/air/airports") }.
          to raise_error(DuffelAPI::Errors::ValidationError)
      end
    end
  end
end
