# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Services::OrderChangesService do
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
    subject(:post_create_response) { client.order_changes.create(params: params) }

    let(:params) do
      {
        selected_order_change_offer: "oco_0000AEdPRxCphZWVywIgT2",
      }
    end

    let(:response_body) { load_fixture("order_changes/show.json") }

    let!(:stub) do
      stub_request(:post, "https://api.duffel.com/air/order_changes").
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
      order_change = post_create_response

      expect(order_change).to be_a(DuffelAPI::Resources::OrderChange)

      expect(order_change.change_total_amount).to eq("125.00")
      expect(order_change.change_total_currency).to eq("GBP")
      expect(order_change.confirmed_at).to be_nil
      expect(order_change.created_at).to eq("2021-12-21T20:56:56.380816Z")
      expect(order_change.expires_at).to eq("2021-12-24T20:56:56Z")
      expect(order_change.id).to eq("oce_0000AEdlOBVlABkDhgsUqW")
      expect(order_change.live_mode).to be(false)
      expect(order_change.new_total_amount).to eq("1067.79")
      expect(order_change.new_total_currency).to eq("GBP")
      expect(order_change.order_id).to eq("ord_0000AEdLCwAsr3d8ceyMwy")
      expect(order_change.penalty_total_amount).to eq("25.00")
      expect(order_change.penalty_total_currency).to eq("GBP")
      expect(order_change.refund_to).to be_nil
      expect(order_change.slices.length).to eq(2)
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
    subject(:get_response) { client.order_changes.get(id) }

    let(:id) { "oce_0000AEdlOBVlABkDhgsUqW" }

    let!(:stub) do
      stub_request(:get, "https://api.duffel.com/air/order_changes/oce_0000AEdlOBVlABkDhgsUqW").
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    let(:response_body) { load_fixture("order_changes/show.json") }

    it "makes the expected request to the Duffel API" do
      get_response
      expect(stub).to have_been_requested
    end

    it "returns an OrderChange resource" do
      order_change = get_response

      expect(order_change).to be_a(DuffelAPI::Resources::OrderChange)

      expect(order_change.change_total_amount).to eq("125.00")
      expect(order_change.change_total_currency).to eq("GBP")
      expect(order_change.confirmed_at).to be_nil
      expect(order_change.created_at).to eq("2021-12-21T20:56:56.380816Z")
      expect(order_change.expires_at).to eq("2021-12-24T20:56:56Z")
      expect(order_change.id).to eq("oce_0000AEdlOBVlABkDhgsUqW")
      expect(order_change.live_mode).to be(false)
      expect(order_change.new_total_amount).to eq("1067.79")
      expect(order_change.new_total_currency).to eq("GBP")
      expect(order_change.order_id).to eq("ord_0000AEdLCwAsr3d8ceyMwy")
      expect(order_change.penalty_total_amount).to eq("25.00")
      expect(order_change.penalty_total_currency).to eq("GBP")
      expect(order_change.refund_to).to be_nil
      expect(order_change.slices.length).to eq(2)
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
    subject(:confirm_response) { client.order_changes.confirm(id, params: params) }

    let(:id) { "oce_0000AEdlOBVlABkDhgsUqW" }

    let(:params) do
      {
        payment: {
          type: "balance",
          currency: "GBP",
          amount: "125.00",
        },
      }
    end

    let!(:stub) do
      stub_request(:post, "https://api.duffel.com/air/order_changes/oce_0000AEdlOBVlABkDhgsUqW/actions/confirm").
        with(body: { data: params }).
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    let(:response_body) { load_fixture("order_changes/show_confirmed.json") }

    it "makes the expected request to the Duffel API" do
      confirm_response
      expect(stub).to have_been_requested
    end

    it "returns an OrderChange resource" do
      order_change = confirm_response

      expect(order_change).to be_a(DuffelAPI::Resources::OrderChange)

      expect(order_change.change_total_amount).to eq("125.00")
      expect(order_change.change_total_currency).to eq("GBP")
      expect(order_change.confirmed_at).to eq("2021-12-21T20:56:56.380816Z")
      expect(order_change.created_at).to eq("2021-12-21T20:56:56.380816Z")
      expect(order_change.expires_at).to eq("2021-12-24T20:56:56Z")
      expect(order_change.id).to eq("oce_0000AEdlOBVlABkDhgsUqW")
      expect(order_change.live_mode).to be(false)
      expect(order_change.new_total_amount).to eq("1067.79")
      expect(order_change.new_total_currency).to eq("GBP")
      expect(order_change.order_id).to eq("ord_0000AEdLCwAsr3d8ceyMwy")
      expect(order_change.penalty_total_amount).to eq("25.00")
      expect(order_change.penalty_total_currency).to eq("GBP")
      expect(order_change.refund_to).to be_nil
      expect(order_change.slices.length).to eq(2)
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
