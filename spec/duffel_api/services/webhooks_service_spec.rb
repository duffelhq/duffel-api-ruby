# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Services::WebhooksService do
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
    subject(:post_create_response) { client.webhooks.create(params: params) }

    let(:params) do
      {
        url: "https://localhost:4567/webhooks",
        events: ["order.created", "order.updated"],
      }
    end

    let(:response_body) { load_fixture("webhooks/show.json") }

    let!(:stub) do
      stub_request(:post, "https://api.duffel.com/air/webhooks").
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

    it "returns a Webhook resource" do
      webhook = post_create_response

      expect(webhook).to be_a(DuffelAPI::Resources::Webhook)

      expect(webhook.active).to be(true)
      expect(webhook.created_at).to eq("2021-12-21T21:09:15.107792Z")
      expect(webhook.events).to eq(["order.created", "order.updated"])
      expect(webhook.id).to eq("sev_0000AEdmUJKCvFK45qMFBg")
      expect(webhook.live_mode).to be(false)
      expect(webhook.secret).to eq("XRcsu65YS0sJ9T0ZUF3pwA==")
      expect(webhook.url).to eq("https://localhost:4567/webhooks")
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

  describe "#update" do
    subject(:patch_update) do
      client.webhooks.update("sev_0000AEdn4HFi6aki5fP8mO", params: params)
    end

    let(:params) do
      {
        active: true,
      }
    end

    let(:response_body) { load_fixture("webhooks/show.json") }

    let!(:stub) do
      stub_request(:patch, "https://api.duffel.com/air/webhooks/sev_0000AEdn4HFi6aki5fP8mO").
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
      patch_update
      expect(stub).to have_been_requested
    end

    it "returns the updated resource" do
      webhook = patch_update

      expect(webhook).to be_a(DuffelAPI::Resources::Webhook)

      expect(webhook.active).to be(true)
      expect(webhook.created_at).to eq("2021-12-21T21:09:15.107792Z")
      expect(webhook.events).to eq(["order.created", "order.updated"])
      expect(webhook.id).to eq("sev_0000AEdmUJKCvFK45qMFBg")
      expect(webhook.live_mode).to be(false)
      expect(webhook.secret).to eq("XRcsu65YS0sJ9T0ZUF3pwA==")
      expect(webhook.url).to eq("https://localhost:4567/webhooks")
    end

    it "exposes the API response" do
      api_response = patch_update.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(200)
    end
  end

  describe "#ping" do
    subject(:ping_webhook) { client.webhooks.ping(id) }

    let(:id) { "sev_0000AEdmUJKCvFK45qMFBg" }

    let!(:stub) do
      stub_request(:post, "https://api.duffel.com/air/webhooks/sev_0000AEdmUJKCvFK45qMFBg/actions/ping").
        to_return(
          body: response_body,
          headers: response_headers,
          status: response_status,
        )
    end

    let(:response_body) { "" }
    let(:response_status) { 204 }
    let(:response_headers) { { "x-request-id" => "FsJz79144I4JjDwAA6TB" } }

    it "makes the expected request to the Duffel API" do
      ping_webhook
      expect(stub).to have_been_requested
    end

    it "returns a PingResult if the ping was successful" do
      expect(ping_webhook).to be_a(described_class::PingResult)
      expect(ping_webhook.succeeded).to be(true)
    end

    it "exposes the API response on the PingResult" do
      api_response = ping_webhook.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(204)
    end

    context "when the ping fails" do
      let(:response_status) { 422 }
      let(:response_body) { load_fixture("webhooks/webhook_client_error.json") }

      let(:response_headers) do
        {
          "content-type" => "application/json",
          "x-request-id" => "FsJz79144I4JjDwAA6TB",
        }
      end

      it "raises the appropriate kind of error" do
        expect { ping_webhook }.to raise_error(DuffelAPI::Errors::InvalidStateError)
      end
    end
  end
end
