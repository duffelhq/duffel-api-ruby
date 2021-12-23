# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Services::OfferRequestsService do
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
    subject(:post_create_response) { client.offer_requests.create(params: params) }

    let(:params) do
      {
        cabin_class: "economy",
        slices: [
          {
            origin: "SYD",
            destination: "MEL",
            departure_date: "2022-04-16",
          },
        ],
        passengers: [
          {
            type: "adult",
          },
        ],
      }
    end

    let(:response_body) { load_fixture("offer_requests/create_with_offers.json") }

    let!(:stub) do
      stub_request(:post, "https://api.duffel.com/air/offer_requests").
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
      offer_request = post_create_response

      expect(offer_request).to be_a(DuffelAPI::Resources::OfferRequest)

      expect(offer_request.slices.length).to eq(1)
      expect(offer_request.passengers.length).to eq(1)
      expect(offer_request.live_mode).to be(false)
      expect(offer_request.id).to eq("orq_0000AEatBgHzrn02B7WwEa")
      expect(offer_request.created_at).to eq("2021-12-20T11:40:11.169611Z")
      expect(offer_request.cabin_class).to be_nil
      expect(offer_request.offers.length).to eq(68)
    end

    it "exposes the API response" do
      api_response = post_create_response.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(200)
    end

    context "asking for offers not to be returned using the `return_offers` parameter" do
      let!(:stub) do
        stub_request(:post, "https://api.duffel.com/air/offer_requests").
          with(
            body: {
              data: params,
            },
            query: { "return_offers" => "false" },
          ).
          to_return(
            body: response_body,
            headers: response_headers,
          )
      end

      it "sends the `return_offers` query parameter as `false`" do
        client.offer_requests.create(params: params.merge(return_offers: false))
        expect(stub).to have_been_requested
      end
    end
  end

  describe "#list" do
    describe "with no filters" do
      subject(:get_list_response) { client.offer_requests.list }

      let(:response_body) { load_fixture("offer_requests/list.json") }

      let!(:stub) do
        stub_request(:get, "https://api.duffel.com/air/offer_requests").to_return(
          body: response_body,
          headers: response_headers,
        )
      end

      it "makes the expected request to the Duffel API" do
        get_list_response
        expect(stub).to have_been_requested
      end

      it "exposes valid OfferRequest resources" do
        expect(get_list_response.records.map(&:class).uniq).
          to eq([DuffelAPI::Resources::OfferRequest])

        offer_request = get_list_response.records.first

        expect(offer_request.slices.length).to eq(1)
        expect(offer_request.passengers.length).to eq(1)
        expect(offer_request.live_mode).to be(false)
        expect(offer_request.id).to eq("orq_0000AEawvIp9k1z6aNUBaS")
        expect(offer_request.created_at).to eq("2021-12-20T12:22:02.773536Z")
        expect(offer_request.cabin_class).to eq("economy")
      end

      it "exposes the cursors for before and after" do
        expect(get_list_response.before).to eq(nil)
        expect(get_list_response.after).to eq("g3QAAAACZAACaWRtAAAAGm9ycV8wMDAwQUVhdzE" \
                                              "yY1Nucks2NndpblkwZAALaW5zZXJ0ZWRfYXR0AA" \
                                              "AADWQACl9fc3RydWN0X19kAA9FbGl4aXIuRGF0Z" \
                                              "VRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxl" \
                                              "bmRhci5JU09kAANkYXlhFGQABGhvdXJhDGQAC21" \
                                              "pY3Jvc2Vjb25kaAJiAAqpwGEGZAAGbWludXRlYQ" \
                                              "tkAAVtb250aGEMZAAGc2Vjb25kYTRkAApzdGRfb" \
                                              "2Zmc2V0YQBkAAl0aW1lX3pvbmVtAAAAB0V0Yy9V" \
                                              "VENkAAp1dGNfb2Zmc2V0YQBkAAR5ZWFyYgAAB-V" \
                                              "kAAl6b25lX2FiYnJtAAAAA1VUQw==")
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

    describe "with parameters" do
      subject(:get_list_response) { client.offer_requests.list(params: { limit: 200 }) }

      let(:response_body) { load_fixture("offer_requests/list.json") }

      let!(:stub) do
        stub_request(:get, "https://api.duffel.com/air/offer_requests").
          with(query: { "limit" => "200" }).
          to_return(
            body: response_body,
            headers: response_headers,
          )
      end

      it "makes the expected request to the Duffel API" do
        get_list_response
        expect(stub).to have_been_requested
      end
    end
  end

  describe "#all" do
    let!(:first_response_stub) do
      stub_request(:get, "https://api.duffel.com/air/offer_requests").to_return(
        body: first_page_response_body,
        headers: response_headers,
      )
    end

    let(:first_page_response_body) { load_fixture("offer_requests/list.json") }

    let(:last_page_response_body) do
      convert_list_response_to_last_page(first_page_response_body)
    end

    let!(:second_response_stub) do
      stub_request(:get, "https://api.duffel.com/air/offer_requests").
        with(query: { "after" => "g3QAAAACZAACaWRtAAAAGm9ycV8wMDAwQUVhdzE" \
                                 "yY1Nucks2NndpblkwZAALaW5zZXJ0ZWRfYXR0AA" \
                                 "AADWQACl9fc3RydWN0X19kAA9FbGl4aXIuRGF0Z" \
                                 "VRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxl" \
                                 "bmRhci5JU09kAANkYXlhFGQABGhvdXJhDGQAC21" \
                                 "pY3Jvc2Vjb25kaAJiAAqpwGEGZAAGbWludXRlYQ" \
                                 "tkAAVtb250aGEMZAAGc2Vjb25kYTRkAApzdGRfb" \
                                 "2Zmc2V0YQBkAAl0aW1lX3pvbmVtAAAAB0V0Yy9V" \
                                 "VENkAAp1dGNfb2Zmc2V0YQBkAAR5ZWFyYgAAB-V" \
                                 "kAAl6b25lX2FiYnJtAAAAA1VUQw==" }).
        to_return(
          body: last_page_response_body,
          headers: response_headers,
        )
    end

    it "automatically makes the extra requests to load all the pages" do
      expect(client.offer_requests.all.to_a.length).to eq(100)
      expect(first_response_stub).to have_been_requested
      expect(second_response_stub).to have_been_requested
    end

    it "exposes valid OfferRequest resources" do
      records = client.offer_requests.all.to_a
      expect(records.map(&:class).uniq).to eq([DuffelAPI::Resources::OfferRequest])
      offer_request = records.first

      expect(offer_request.slices.length).to eq(1)
      expect(offer_request.passengers.length).to eq(1)
      expect(offer_request.live_mode).to be(false)
      expect(offer_request.id).to eq("orq_0000AEawvIp9k1z6aNUBaS")
      expect(offer_request.created_at).to eq("2021-12-20T12:22:02.773536Z")
      expect(offer_request.cabin_class).to eq("economy")
    end

    it "exposes the API response" do
      records = client.offer_requests.all
      api_response = records.first.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(200)
    end
  end

  describe "#get" do
    subject(:get_response) { client.offer_requests.get(id) }

    let(:id) { "orq_0000AEaw0wBYAwGG9tNnm4" }

    let!(:stub) do
      stub_request(:get, "https://api.duffel.com/air/offer_requests/orq_0000AEaw0wBYAwGG9tNnm4").
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    let(:response_body) { load_fixture("offer_requests/show.json") }

    it "makes the expected request to the Duffel API" do
      get_response
      expect(stub).to have_been_requested
    end

    it "returns an OfferRequest resource" do
      offer_request = get_response

      expect(offer_request).to be_a(DuffelAPI::Resources::OfferRequest)

      expect(offer_request.slices.length).to eq(1)
      expect(offer_request.passengers.length).to eq(1)
      expect(offer_request.live_mode).to be(false)
      expect(offer_request.id).to eq("orq_0000AEaw0wBYAwGG9tNnm4")
      expect(offer_request.created_at).to eq("2021-12-20T12:11:51.573119Z")
      expect(offer_request.cabin_class).to eq("economy")
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
