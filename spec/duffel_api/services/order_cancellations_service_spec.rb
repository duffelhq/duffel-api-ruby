# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Services::OrderCancellationsService do
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
    subject(:post_create_response) { client.order_cancellations.create(params: params) }

    let(:params) do
      {
        order_id: "ord_0000AEMtG5Awt5i1RDfCUa",
      }
    end

    let(:response_body) { load_fixture("order_cancellations/show.json") }

    let!(:stub) do
      stub_request(:post, "https://api.duffel.com/air/order_cancellations").
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

    it "creates and returns the resource" do
      order_cancellation = post_create_response

      expect(order_cancellation).to be_a(DuffelAPI::Resources::OrderCancellation)

      expect(order_cancellation.confirmed_at).to eq("2021-12-17T14:42:46.367082Z")
      expect(order_cancellation.created_at).to eq("2021-12-17T14:40:23.924929Z")
      expect(order_cancellation.expires_at).to be_nil
      expect(order_cancellation.id).to eq("ore_0000AEUvjGoJlav2j6FDlZ")
      expect(order_cancellation.live_mode).to be(false)
      expect(order_cancellation.order_id).to eq("ord_0000AEMtG5Awt5i1RDfCUa")
      expect(order_cancellation.refund_amount).to eq("177.80")
      expect(order_cancellation.refund_currency).to eq("GBP")
      expect(order_cancellation.refund_to).to eq("balance")
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

  describe "#list" do
    subject(:get_list_response) do
      client.order_cancellations.list
    end

    let(:response_body) { load_fixture("order_cancellations/list.json") }

    let!(:stub) do
      stub_request(:get, "https://api.duffel.com/air/order_cancellations").
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    it "makes the expected request to the Duffel API" do
      get_list_response
      expect(stub).to have_been_requested
    end

    it "exposes valid OrderCancellation resources" do
      expect(get_list_response.records.map(&:class).uniq).
        to eq([DuffelAPI::Resources::OrderCancellation])

      order_cancellation = get_list_response.records.first

      expect(order_cancellation.confirmed_at).to eq("2021-12-17T14:42:46.367082Z")
      expect(order_cancellation.created_at).to eq("2021-12-17T14:40:23.924929Z")
      expect(order_cancellation.expires_at).to be_nil
      expect(order_cancellation.id).to eq("ore_0000AEUvjGoJlav2j6FDlZ")
      expect(order_cancellation.live_mode).to be(false)
      expect(order_cancellation.order_id).to eq("ord_0000AEMtG5Awt5i1RDfCUa")
      expect(order_cancellation.refund_amount).to eq("177.80")
      expect(order_cancellation.refund_currency).to eq("GBP")
      expect(order_cancellation.refund_to).to eq("balance")
    end

    it "exposes the cursors for before and after" do
      expect(get_list_response.before).to eq(nil)
      expect(get_list_response.after).to eq("g3QAAAACZAACaWRtAAAAGm9yZV8wMDAwQThMNDhZT" \
                                            "VlYVGlnVmlLZFpnZAALaW5zZXJ0ZWRfYXR0AAAADW" \
                                            "QACl9fc3RydWN0X19kAA9FbGl4aXIuRGF0ZVRpbWV" \
                                            "kAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5J" \
                                            "U09kAANkYXlhEGQABGhvdXJhCWQAC21pY3Jvc2Vjb" \
                                            "25kaAJiAAP8J2EGZAAGbWludXRlYQ5kAAVtb250aG" \
                                            "EGZAAGc2Vjb25kYTVkAApzdGRfb2Zmc2V0YQBkAAl" \
                                            "0aW1lX3pvbmVtAAAAB0V0Yy9VVENkAAp1dGNfb2Zm" \
                                            "c2V0YQBkAAR5ZWFyYgAAB-VkAAl6b25lX2FiYnJtA" \
                                            "AAAA1VUQw==")
    end

    it "exposes the API response" do
      api_response = get_list_response.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(200)
    end
  end

  describe "#all" do
    let!(:first_response_stub) do
      stub_request(:get, "https://api.duffel.com/air/order_cancellations").
        to_return(
          body: first_page_response_body,
          headers: response_headers,
        )
    end

    let(:first_page_response_body) { load_fixture("order_cancellations/list.json") }

    let(:last_page_response_body) do
      convert_list_response_to_last_page(first_page_response_body)
    end

    let!(:second_response_stub) do
      stub_request(:get, "https://api.duffel.com/air/order_cancellations").
        with(query: { "after" => "g3QAAAACZAACaWRtAAAAGm9yZV8wMDAwQThMNDhZT" \
                                 "VlYVGlnVmlLZFpnZAALaW5zZXJ0ZWRfYXR0AAAADW" \
                                 "QACl9fc3RydWN0X19kAA9FbGl4aXIuRGF0ZVRpbWV" \
                                 "kAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5J" \
                                 "U09kAANkYXlhEGQABGhvdXJhCWQAC21pY3Jvc2Vjb" \
                                 "25kaAJiAAP8J2EGZAAGbWludXRlYQ5kAAVtb250aG" \
                                 "EGZAAGc2Vjb25kYTVkAApzdGRfb2Zmc2V0YQBkAAl" \
                                 "0aW1lX3pvbmVtAAAAB0V0Yy9VVENkAAp1dGNfb2Zm" \
                                 "c2V0YQBkAAR5ZWFyYgAAB-VkAAl6b25lX2FiYnJtA" \
                                 "AAAA1VUQw==" }).
        to_return(
          body: last_page_response_body,
          headers: response_headers,
        )
    end

    it "automatically makes the extra requests to load all the pages" do
      expect(client.order_cancellations.all.to_a.length).to eq(100)
      expect(first_response_stub).to have_been_requested
      expect(second_response_stub).to have_been_requested
    end

    it "exposes valid OrderCancellation resources" do
      records = client.order_cancellations.all.to_a
      expect(records.map(&:class).uniq).to eq([DuffelAPI::Resources::OrderCancellation])
      order_cancellation = records.first

      expect(order_cancellation.confirmed_at).to eq("2021-12-17T14:42:46.367082Z")
      expect(order_cancellation.created_at).to eq("2021-12-17T14:40:23.924929Z")
      expect(order_cancellation.expires_at).to be_nil
      expect(order_cancellation.id).to eq("ore_0000AEUvjGoJlav2j6FDlZ")
      expect(order_cancellation.live_mode).to be(false)
      expect(order_cancellation.order_id).to eq("ord_0000AEMtG5Awt5i1RDfCUa")
      expect(order_cancellation.refund_amount).to eq("177.80")
      expect(order_cancellation.refund_currency).to eq("GBP")
      expect(order_cancellation.refund_to).to eq("balance")
    end

    it "exposes the API response on the resources" do
      records = client.order_cancellations.all
      api_response = records.first.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(200)
    end
  end

  describe "#get" do
    subject(:get_response) { client.order_cancellations.get(id) }

    let(:id) { "ore_0000AEUvjGoJlav2j6FDlZ" }

    let!(:stub) do
      stub_request(:get, "https://api.duffel.com/air/order_cancellations/ore_0000AEUvjGoJlav2j6FDlZ").
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    let(:response_body) { load_fixture("order_cancellations/show.json") }

    it "makes the expected request to the Duffel API" do
      get_response
      expect(stub).to have_been_requested
    end

    it "returns an OrderCancellation resource" do
      order_cancellation = get_response

      expect(order_cancellation).to be_a(DuffelAPI::Resources::OrderCancellation)

      expect(order_cancellation.confirmed_at).to eq("2021-12-17T14:42:46.367082Z")
      expect(order_cancellation.created_at).to eq("2021-12-17T14:40:23.924929Z")
      expect(order_cancellation.expires_at).to be_nil
      expect(order_cancellation.id).to eq("ore_0000AEUvjGoJlav2j6FDlZ")
      expect(order_cancellation.live_mode).to be(false)
      expect(order_cancellation.order_id).to eq("ord_0000AEMtG5Awt5i1RDfCUa")
      expect(order_cancellation.refund_amount).to eq("177.80")
      expect(order_cancellation.refund_currency).to eq("GBP")
      expect(order_cancellation.refund_to).to eq("balance")
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
    subject(:confirm_response) { client.order_cancellations.confirm(id) }

    let(:id) { "ore_0000AEUvjGoJlav2j6FDlZ" }

    let!(:stub) do
      stub_request(:post, "https://api.duffel.com/air/order_cancellations/ore_0000AEUvjGoJlav2j6FDlZ/actions/confirm").
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    let(:response_body) { load_fixture("order_cancellations/show.json") }

    it "makes the expected request to the Duffel API" do
      confirm_response
      expect(stub).to have_been_requested
    end

    it "returns an OrderCancellation resource" do
      order_cancellation = confirm_response

      expect(order_cancellation).to be_a(DuffelAPI::Resources::OrderCancellation)

      expect(order_cancellation.confirmed_at).to eq("2021-12-17T14:42:46.367082Z")
      expect(order_cancellation.created_at).to eq("2021-12-17T14:40:23.924929Z")
      expect(order_cancellation.expires_at).to be_nil
      expect(order_cancellation.id).to eq("ore_0000AEUvjGoJlav2j6FDlZ")
      expect(order_cancellation.live_mode).to be(false)
      expect(order_cancellation.order_id).to eq("ord_0000AEMtG5Awt5i1RDfCUa")
      expect(order_cancellation.refund_amount).to eq("177.80")
      expect(order_cancellation.refund_currency).to eq("GBP")
      expect(order_cancellation.refund_to).to eq("balance")
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
