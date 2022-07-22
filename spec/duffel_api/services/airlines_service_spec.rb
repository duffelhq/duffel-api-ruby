# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Services::AirlinesService do
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
      subject(:get_list_response) { client.airlines.list }

      let(:response_body) { load_fixture("airlines/list.json") }

      let!(:stub) do
        stub_request(:get, "https://api.duffel.com/air/airlines").to_return(
          body: response_body,
          headers: response_headers,
        )
      end

      it "makes the expected request to the Duffel API" do
        get_list_response
        expect(stub).to have_been_requested
      end

      it "exposes valid Airline resources" do
        expect(get_list_response.records.map(&:class).uniq).
          to eq([DuffelAPI::Resources::Airline])

        airline = get_list_response.records.first

        expect(airline.iata_code).to eq("12")
        expect(airline.id).to eq("arl_00009VME7DEWSV8v1yhJgK")
        expect(airline.name).to eq("12 North")
        expect(airline.logo_lockup_url).to eq("https://assets.duffel.com/img/airlines/for-light-background/full-color-lockup/12.svg")
        expect(airline.logo_symbol_url).to eq("https://assets.duffel.com/img/airlines/for-light-background/full-color-logo/12.svg")
      end

      it "exposes the cursors for before and after" do
        expect(get_list_response.before).to be_nil
        expect(get_list_response.after).to eq("g3QAAAACZAACaWRtAAAAGmFybF8wMDAwOVZNRTd" \
                                              "EQUdpSmp3b21odjM1ZAAEbmFtZW0AAAARQWZyaX" \
                                              "FpeWFoIEFpcndheXM=")
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
      subject(:get_list_response) { client.airlines.list(params: { limit: 200 }) }

      let(:response_body) { load_fixture("airlines/list.json") }

      let!(:stub) do
        stub_request(:get, "https://api.duffel.com/air/airlines").
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
    let(:first_page_response_body) { load_fixture("airlines/list.json") }

    let(:last_page_response_body) do
      convert_list_response_to_last_page(first_page_response_body)
    end

    let(:expected_query_params) do
      { limit: 200 }
    end

    let!(:first_response_stub) do
      stub_request(:get, "https://api.duffel.com/air/airlines").
        with(query: expected_query_params).
        to_return(
          body: first_page_response_body,
          headers: response_headers,
        )
    end

    let!(:second_response_stub) do
      stub_request(:get, "https://api.duffel.com/air/airlines").
        with(query: expected_query_params.merge(
          after: "g3QAAAACZAACaWRtAAAAGmFybF8wMDAwOVZNRTdEQUdpSmp3b21odjM1ZAAEbmFtZW0AA" \
                 "AARQWZyaXFpeWFoIEFpcndheXM=",
        )).
        to_return(
          body: last_page_response_body,
          headers: response_headers,
        )
    end

    it "automatically makes the requests to load all pages, 200 results at a time" do
      expect(client.airlines.all.to_a.length).to eq(100)
      expect(first_response_stub).to have_been_requested
      expect(second_response_stub).to have_been_requested
    end

    it "exposes valid Airline resources" do
      records = client.airlines.all.to_a
      expect(records.map(&:class).uniq).to eq([DuffelAPI::Resources::Airline])
      airline = records.first

      expect(airline.iata_code).to eq("12")
      expect(airline.id).to eq("arl_00009VME7DEWSV8v1yhJgK")
      expect(airline.name).to eq("12 North")
    end

    it "exposes the API response on resources" do
      records = client.airlines.all.to_a
      api_response = records.first.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(200)
    end

    context "customising the limit per page" do
      let(:expected_query_params) do
        { limit: 33 }
      end

      it "requests the requested number of items per page from the API" do
        client.airlines.
          all(params: { limit: 33 }).
          to_a

        expect(first_response_stub).to have_been_requested
        expect(second_response_stub).to have_been_requested
      end
    end
  end

  describe "#get" do
    subject(:get_response) { client.airlines.get(id) }

    let(:id) { "arl_00009VME7DEWSV8v1yhJgK" }

    let!(:stub) do
      stub_request(:get, "https://api.duffel.com/air/airlines/arl_00009VME7DEWSV8v1yhJgK").
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    let(:response_body) { load_fixture("airlines/show.json") }

    it "makes the expected request to the Duffel API" do
      get_response
      expect(stub).to have_been_requested
    end

    it "returns an Airline resource" do
      expect(get_response).to be_a(DuffelAPI::Resources::Airline)

      expect(get_response.iata_code).to eq("12")
      expect(get_response.id).to eq("arl_00009VME7DEWSV8v1yhJgK")
      expect(get_response.name).to eq("12 North")
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
