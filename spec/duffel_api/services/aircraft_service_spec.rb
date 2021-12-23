# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Services::AircraftService do
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
      subject(:get_list_response) { client.aircraft.list }

      let(:response_body) { load_fixture("aircraft/list.json") }

      let!(:stub) do
        stub_request(:get, "https://api.duffel.com/air/aircraft").to_return(
          body: response_body,
          headers: response_headers,
        )
      end

      it "makes the expected request to the Duffel API" do
        get_list_response
        expect(stub).to have_been_requested
      end

      it "exposes valid Aircraft resources" do
        expect(get_list_response.records.map(&:class).uniq).
          to eq([DuffelAPI::Resources::Aircraft])

        aircraft = get_list_response.records.first

        expect(aircraft.iata_code).to eq("AT5")
        expect(aircraft.id).to eq("arc_00009VMF8AhXSSRnQDI6Hi")
        expect(aircraft.name).to eq("Aerospatiale/Alenia ATR 42-500")
      end

      it "exposes the cursors for before and after" do
        expect(get_list_response.before).to eq(nil)
        expect(get_list_response.after).to eq("g3QAAAACZAACaWRtAAAAGmFyY18wMDAwOVZNRjh" \
                                              "BZ3BWNXNkTzB4WEIwZAAEbmFtZW0AAAAPQWlyYn" \
                                              "VzIEEzNDAtNTAw")
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
      subject(:get_list_response) { client.aircraft.list(params: { limit: 200 }) }

      let(:response_body) { load_fixture("aircraft/list.json") }

      let!(:stub) do
        stub_request(:get, "https://api.duffel.com/air/aircraft").
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
      stub_request(:get, "https://api.duffel.com/air/aircraft").to_return(
        body: first_page_response_body,
        headers: response_headers,
      )
    end

    let(:first_page_response_body) { load_fixture("aircraft/list.json") }

    let(:last_page_response_body) do
      convert_list_response_to_last_page(first_page_response_body)
    end

    let!(:second_response_stub) do
      stub_request(:get, "https://api.duffel.com/air/aircraft").
        with(query: { "after" => "g3QAAAACZAACaWRtAAAAGmFyY18wMDAwOVZNRjh" \
                                 "BZ3BWNXNkTzB4WEIwZAAEbmFtZW0AAAAPQWlyYn" \
                                 "VzIEEzNDAtNTAw" }).
        to_return(
          body: last_page_response_body,
          headers: response_headers,
        )
    end

    it "automatically makes the extra requests to load all the pages" do
      expect(client.aircraft.all.to_a.length).to eq(100)
      expect(first_response_stub).to have_been_requested
      expect(second_response_stub).to have_been_requested
    end

    it "exposes valid Aircraft resources" do
      records = client.aircraft.all.to_a
      expect(records.map(&:class).uniq).to eq([DuffelAPI::Resources::Aircraft])
      aircraft = records.first

      expect(aircraft.iata_code).to eq("AT5")
      expect(aircraft.id).to eq("arc_00009VMF8AhXSSRnQDI6Hi")
      expect(aircraft.name).to eq("Aerospatiale/Alenia ATR 42-500")
    end

    it "exposes the API response on resources" do
      records = client.aircraft.all.to_a
      api_response = records.first.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(200)
    end
  end

  describe "#get" do
    subject(:get_response) { client.aircraft.get(id) }

    let(:id) { "arc_00009VMF8AhXSSRnQDI6Hi" }

    let!(:stub) do
      stub_request(:get, "https://api.duffel.com/air/aircraft/arc_00009VMF8AhXSSRnQDI6Hi").
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    let(:response_body) { load_fixture("aircraft/show.json") }

    it "makes the expected request to the Duffel API" do
      get_response
      expect(stub).to have_been_requested
    end

    it "returns an Aircraft resource" do
      expect(get_response).to be_a(DuffelAPI::Resources::Aircraft)

      expect(get_response.iata_code).to eq("AT5")
      expect(get_response.id).to eq("arc_00009VMF8AhXSSRnQDI6Hi")
      expect(get_response.name).to eq("Aerospatiale/Alenia ATR 42-500")
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
