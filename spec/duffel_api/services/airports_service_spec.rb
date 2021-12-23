# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Services::AirportsService do
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
    describe "with no filters" do
      subject(:get_list_response) { client.airports.list }

      let(:response_body) { load_fixture("airports/list.json") }

      let!(:stub) do
        stub_request(:get, "https://api.duffel.com/air/airports").to_return(
          body: response_body,
          headers: response_headers,
        )
      end

      it "makes the expected request to the Duffel API" do
        get_list_response
        expect(stub).to have_been_requested
      end

      it "exposes valid Airport resources" do
        expect(get_list_response.records.map(&:class).uniq).
          to eq([DuffelAPI::Resources::Airport])

        airport = get_list_response.records.first

        expect(airport.city).to be_nil
        expect(airport.city_name).to eq("Aachen")
        expect(airport.iata_code).to eq("AAH")
        expect(airport.iata_country_code).to eq("DE")
        expect(airport.icao_code).to eq("EDKA")
        expect(airport.id).to eq("arp_aah_de")
        expect(airport.latitude).to eq(50.823345)
        expect(airport.longitude).to eq(6.186722)
        expect(airport.name).to eq("Aachen Merzbrück Airfield")
        expect(airport.time_zone).to eq("Europe/Berlin")
      end

      it "exposes the cursors for before and after" do
        expect(get_list_response.before).to eq(nil)
        expect(get_list_response.after).to eq("g3QAAAACZAACaWRtAAAACmFycF9hZGxfYXVkAA" \
                                              "RuYW1lbQAAABBBZGVsYWlkZSBBaXJwb3J0")
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
      subject(:get_list_response) { client.airports.list(params: { limit: 200 }) }

      let(:response_body) { load_fixture("airports/list.json") }

      let!(:stub) do
        stub_request(:get, "https://api.duffel.com/air/airports").
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
      stub_request(:get, "https://api.duffel.com/air/airports").to_return(
        body: first_page_response_body,
        headers: response_headers,
      )
    end

    let(:first_page_response_body) { load_fixture("airports/list.json") }

    let(:last_page_response_body) do
      convert_list_response_to_last_page(first_page_response_body)
    end

    let!(:second_response_stub) do
      stub_request(:get, "https://api.duffel.com/air/airports").
        with(query: { "after" => "g3QAAAACZAACaWRtAAAACmFycF9hZGxfYXVkAARuYW1lbQAAABBB" \
                                 "ZGVsYWlkZSBBaXJwb3J0" }).
        to_return(
          body: last_page_response_body,
          headers: response_headers,
        )
    end

    it "automatically makes the extra requests to load all the pages" do
      expect(client.airports.all.to_a.length).to eq(100)
      expect(first_response_stub).to have_been_requested
      expect(second_response_stub).to have_been_requested
    end

    it "exposes valid Airport resources" do
      records = client.airports.all.to_a
      expect(records.map(&:class).uniq).to eq([DuffelAPI::Resources::Airport])
      airport = records.first

      expect(airport.city).to be_nil
      expect(airport.city_name).to eq("Aachen")
      expect(airport.iata_code).to eq("AAH")
      expect(airport.iata_country_code).to eq("DE")
      expect(airport.icao_code).to eq("EDKA")
      expect(airport.id).to eq("arp_aah_de")
      expect(airport.latitude).to eq(50.823345)
      expect(airport.longitude).to eq(6.186722)
      expect(airport.name).to eq("Aachen Merzbrück Airfield")
      expect(airport.time_zone).to eq("Europe/Berlin")
    end

    it "exposes the API response" do
      records = client.airports.all.to_a
      api_response = records.first.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(200)
    end
  end

  describe "#get" do
    subject(:get_response) { client.airports.get(id) }

    let(:id) { "arp_mgq_so" }

    let!(:stub) do
      stub_request(:get, "https://api.duffel.com/air/airports/arp_mgq_so").
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    let(:response_body) { load_fixture("airports/show.json") }

    it "makes the expected request to the Duffel API" do
      get_response
      expect(stub).to have_been_requested
    end

    it "returns an Airport resource" do
      expect(get_response).to be_a(DuffelAPI::Resources::Airport)

      expect(get_response.city).to be_nil
      expect(get_response.city_name).to eq("Mogadishu")
      expect(get_response.iata_code).to eq("MGQ")
      expect(get_response.iata_country_code).to eq("SO")
      expect(get_response.icao_code).to eq("HCMM")
      expect(get_response.id).to eq("arp_mgq_so")
      expect(get_response.latitude).to eq(2.015817)
      expect(get_response.longitude).to eq(45.304832)
      expect(get_response.name).to eq("Aden Adde International Airport")
      expect(get_response.time_zone).to eq("Africa/Mogadishu")
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
