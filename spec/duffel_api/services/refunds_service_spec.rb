# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Services::RefundsService do
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
    subject(:post_create_response) { client.refunds.create(params: params) }

    let(:params) do
      {
        amount: "100.00",
        currency: "GBP",
        payment_intent_id: "pit_0000AEdrOAmsp2uXNytkrA",
      }
    end

    let(:response_body) { load_fixture("refunds/show.json") }

    let!(:stub) do
      stub_request(:post, "https://api.duffel.com/payments/refunds").
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

    it "returns a Refund resource" do
      refund = post_create_response

      expect(refund).to be_a(DuffelAPI::Resources::Refund)

      expect(refund.amount).to eq("100.00")
      expect(refund.arrival).to eq("Credit approximately 5-10 business days later, " \
                                   "depending upon the bank.")
      expect(refund.created_at).to eq("2021-12-21T22:02:41.194906Z")
      expect(refund.currency).to eq("GBP")
      expect(refund.destination).to eq("original_form_of_payment")
      expect(refund.id).to eq("ref_0000AEdrOAv2KjQtnGiGZ6")
      expect(refund.live_mode).to eq(false)
      expect(refund.net_amount).to eq("100.00")
      expect(refund.net_currency).to eq("GBP")
      expect(refund.payment_intent_id).to eq("pit_0000AEdrOAmsp2uXNytkrA")
      expect(refund.status).to eq("succeeded")
      expect(refund.updated_at).to eq("2021-12-21T22:02:41.194906Z")
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
    subject(:get_response) { client.refunds.get(id) }

    let(:id) { "ref_0000AEdrOAv2KjQtnGiGZ6" }

    let!(:stub) do
      stub_request(:get, "https://api.duffel.com/payments/refunds/ref_0000AEdrOAv2KjQtnGiGZ6").
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    let(:response_body) { load_fixture("refunds/show.json") }

    it "makes the expected request to the Duffel API" do
      get_response
      expect(stub).to have_been_requested
    end

    it "returns a Refund resource" do
      refund = get_response

      expect(refund).to be_a(DuffelAPI::Resources::Refund)

      expect(refund.amount).to eq("100.00")
      expect(refund.arrival).to eq("Credit approximately 5-10 business days later, " \
                                   "depending upon the bank.")
      expect(refund.created_at).to eq("2021-12-21T22:02:41.194906Z")
      expect(refund.currency).to eq("GBP")
      expect(refund.destination).to eq("original_form_of_payment")
      expect(refund.id).to eq("ref_0000AEdrOAv2KjQtnGiGZ6")
      expect(refund.live_mode).to eq(false)
      expect(refund.net_amount).to eq("100.00")
      expect(refund.net_currency).to eq("GBP")
      expect(refund.payment_intent_id).to eq("pit_0000AEdrOAmsp2uXNytkrA")
      expect(refund.status).to eq("succeeded")
      expect(refund.updated_at).to eq("2021-12-21T22:02:41.194906Z")
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
end
