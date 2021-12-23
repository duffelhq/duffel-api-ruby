# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Services::PaymentsService do
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
    subject(:post_create_response) { client.payments.create(params: params) }

    let(:params) do
      {
        order_id: "ord_0000AEdLCwAsr3d8ceyMwy",
        payment: {
          type: "balance",
          amount: "967.79",
          currency: "GBP",
        },
      }
    end

    let(:response_body) { load_fixture("payments/show.json") }

    let!(:stub) do
      stub_request(:post, "https://api.duffel.com/air/payments").
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

    it "returns the resource" do
      payment = post_create_response

      expect(payment).to be_a(DuffelAPI::Resources::Payment)

      expect(payment.amount).to eq("967.79")
      expect(payment.created_at).to eq("2021-12-21T16:06:32.531661Z")
      expect(payment.currency).to eq("GBP")
      expect(payment.id).to eq("pay_0000AEdLTLasItzU4tTCS0")
      expect(payment.type).to eq("balance")
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
end
