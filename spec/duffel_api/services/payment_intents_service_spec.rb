# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Services::PaymentIntentsService do
  let(:client) do
    DuffelAPI::Client.new(
      access_token: "secret_token",
    )
  end

  let(:response_headers) do
    {
      "content-type" => "application/json",
      "x-request-id" => "FsJz79144I4JjDwAA6TB",
    }
  end

  describe "#create" do
    subject(:post_create_response) { client.payment_intents.create(params: params) }

    let(:params) do
      {
        amount: "100.00",
        currency: "GBP",
      }
    end

    let(:response_body) { load_fixture("payment_intents/show.json") }

    let!(:stub) do
      stub_request(:post, "https://api.duffel.com/payments/payment_intents").
        with(
          body: {
            data: params,
          },
        ).
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    it "makes the expected request to the Duffel API" do
      post_create_response
      expect(stub).to have_been_requested
    end

    it "returns a PaymentIntent resource" do
      payment_intent = post_create_response

      expect(payment_intent).to be_a(DuffelAPI::Resources::PaymentIntent)

      expect(payment_intent.amount).to eq("100.00")
      expect(payment_intent.card_country_code).to be_nil
      expect(payment_intent.card_last_four_digits).to eq("4242")
      expect(payment_intent.card_network).to eq("visa")
      expect(payment_intent.client_token).to be_nil
      expect(payment_intent.confirmed_at).to eq("2021-12-21T22:02:41.518874Z")
      expect(payment_intent.created_at).to eq("2021-12-21T22:02:41.194906Z")
      expect(payment_intent.currency).to eq("GBP")
      expect(payment_intent.fees_amount).to be_nil
      expect(payment_intent.fees_currency).to be_nil
      expect(payment_intent.id).to eq("pit_0000AEdrFygFx3lVWJtI00")
      expect(payment_intent.live_mode).to be(false)
      expect(payment_intent.net_amount).to be_nil
      expect(payment_intent.net_currency).to be_nil
      expect(payment_intent.refunds).to eq([])
      expect(payment_intent.status).to eq("succeeded")
      expect(payment_intent.updated_at).to eq("2021-12-21T22:02:41.194906Z")
    end

    it "exposes the API response" do
      api_response = post_create_response.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(200)
    end
  end

  describe "#get" do
    subject(:get_response) { client.payment_intents.get(id) }

    let(:id) { "pit_0000AEdrFygFx3lVWJtI00" }

    let!(:stub) do
      stub_request(:get, "https://api.duffel.com/payments/payment_intents/pit_0000AEdrFygFx3lVWJtI00").
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    let(:response_body) { load_fixture("payment_intents/show.json") }

    it "makes the expected request to the Duffel API" do
      get_response
      expect(stub).to have_been_requested
    end

    it "returns a PaymentIntent resource" do
      payment_intent = get_response

      expect(payment_intent).to be_a(DuffelAPI::Resources::PaymentIntent)

      expect(payment_intent.amount).to eq("100.00")
      expect(payment_intent.card_country_code).to be_nil
      expect(payment_intent.card_last_four_digits).to eq("4242")
      expect(payment_intent.card_network).to eq("visa")
      expect(payment_intent.client_token).to be_nil
      expect(payment_intent.confirmed_at).to eq("2021-12-21T22:02:41.518874Z")
      expect(payment_intent.created_at).to eq("2021-12-21T22:02:41.194906Z")
      expect(payment_intent.currency).to eq("GBP")
      expect(payment_intent.fees_amount).to be_nil
      expect(payment_intent.fees_currency).to be_nil
      expect(payment_intent.id).to eq("pit_0000AEdrFygFx3lVWJtI00")
      expect(payment_intent.live_mode).to be(false)
      expect(payment_intent.net_amount).to be_nil
      expect(payment_intent.net_currency).to be_nil
      expect(payment_intent.refunds).to eq([])
      expect(payment_intent.status).to eq("succeeded")
      expect(payment_intent.updated_at).to eq("2021-12-21T22:02:41.194906Z")
    end

    it "exposes the API response" do
      api_response = get_response.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(200)
    end
  end

  describe "#confirm" do
    subject(:confirm_response) { client.payment_intents.confirm(id) }

    let(:id) { "pit_0000AEdrFygFx3lVWJtI00" }

    let!(:stub) do
      stub_request(:post, "https://api.duffel.com/payments/payment_intents/pit_0000AEdrFygFx3lVWJtI00/actions/confirm").
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    let(:response_body) { load_fixture("payment_intents/show.json") }

    it "makes the expected request to the Duffel API" do
      confirm_response
      expect(stub).to have_been_requested
    end

    it "returns a PaymentIntent resource" do
      payment_intent = confirm_response

      expect(payment_intent).to be_a(DuffelAPI::Resources::PaymentIntent)

      expect(payment_intent.amount).to eq("100.00")
      expect(payment_intent.card_country_code).to be_nil
      expect(payment_intent.card_last_four_digits).to eq("4242")
      expect(payment_intent.card_network).to eq("visa")
      expect(payment_intent.client_token).to be_nil
      expect(payment_intent.confirmed_at).to eq("2021-12-21T22:02:41.518874Z")
      expect(payment_intent.created_at).to eq("2021-12-21T22:02:41.194906Z")
      expect(payment_intent.currency).to eq("GBP")
      expect(payment_intent.fees_amount).to be_nil
      expect(payment_intent.fees_currency).to be_nil
      expect(payment_intent.id).to eq("pit_0000AEdrFygFx3lVWJtI00")
      expect(payment_intent.live_mode).to be(false)
      expect(payment_intent.net_amount).to be_nil
      expect(payment_intent.net_currency).to be_nil
      expect(payment_intent.refunds).to eq([])
      expect(payment_intent.status).to eq("succeeded")
      expect(payment_intent.updated_at).to eq("2021-12-21T22:02:41.194906Z")
    end

    it "exposes the API response" do
      api_response = confirm_response.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(200)
    end
  end
end
