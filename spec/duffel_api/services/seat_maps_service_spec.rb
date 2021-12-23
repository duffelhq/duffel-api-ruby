# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Services::SeatMapsService do
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

  describe "#list" do
    subject(:get_list_response) { client.seat_maps.list(params: { offer_id: "" }) }

    let(:response_body) { load_fixture("seat_maps/list.json") }

    let!(:stub) do
      stub_request(:get, "https://api.duffel.com/air/seat_maps").
        with(query: { "offer_id" => "" }).
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    it "makes the expected request to the Duffel API" do
      get_list_response
      expect(stub).to have_been_requested
    end

    it "exposes valid SeatMap resources" do
      expect(get_list_response.records.map(&:class).uniq).
        to eq([DuffelAPI::Resources::SeatMap])

      seat_map = get_list_response.records.first

      expect(seat_map.cabins.length).to eq(1)
      expect(seat_map.id).to eq("sea_0000AEdMMTAtd7q7X05VCc")
      expect(seat_map.segment_id).to eq("seg_0000AEdLBVw9JQqmToWF9b")
      expect(seat_map.slice_id).to eq("sli_0000AEdLBVw9JQqmToWF9Z")
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
end
