# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Services::CitiesService do
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
      subject(:get_list_response) { client.cities.list }

      let(:response_body) { load_fixture("cities/list.json") }

      let!(:stub) do
        stub_request(:get, "https://api.duffel.com/air/cities").to_return(
          body: response_body,
          headers: response_headers,
        )
      end

      it "makes the expected request to the Duffel API" do
        get_list_response
        expect(stub).to have_been_requested
      end

      it "exposes valid City resources" do
        expect(get_list_response.records.map(&:class).uniq).
          to eq([DuffelAPI::Resources::City])

        city = get_list_response.records.first

        expect(city.iata_code).to eq("ABI")
        expect(city.iata_country_code).to eq("US")
        expect(city.id).to eq("cit_abi_us")
        expect(city.name).to eq("Abilene")
      end

      it "exposes the cursors for before and after" do
        expect(get_list_response.before).to be_nil
        expect(get_list_response.after).to eq("g3QAAAACdwJpZG0AAAAKY2l0X2Nvc191c3" \
                                              "cEbmFtZW0AAAAQQ29sb3JhZG8gU3ByaW5ncw==")
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
      subject(:get_list_response) { client.cities.list(params: { limit: 200 }) }

      let(:response_body) { load_fixture("cities/list.json") }

      let!(:stub) do
        stub_request(:get, "https://api.duffel.com/air/cities").
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
    let(:first_page_response_body) { load_fixture("cities/list.json") }

    let(:last_page_response_body) do
      convert_list_response_to_last_page(first_page_response_body)
    end

    let(:expected_query_params) do
      { limit: 200 }
    end

    let!(:first_response_stub) do
      stub_request(:get, "https://api.duffel.com/air/cities").
        with(query: expected_query_params).
        to_return(
          body: first_page_response_body,
          headers: response_headers,
        )
    end

    let!(:second_response_stub) do
      stub_request(:get, "https://api.duffel.com/air/cities").
        with(query: expected_query_params.merge(
          "after" => "g3QAAAACdwJpZG0AAAAKY2l0X2Nvc191c3cEbmFtZW0AAAAQQ29sb3JhZG8gU3B" \
                     "yaW5ncw==",
        )).
        to_return(
          body: last_page_response_body,
          headers: response_headers,
        )
    end

    it "automatically makes the requests to load all pages, 200 results at a time" do
      expect(client.cities.all.to_a.length).to eq(100)
      expect(first_response_stub).to have_been_requested
      expect(second_response_stub).to have_been_requested
    end

    it "exposes valid City resources" do
      records = client.cities.all.to_a
      expect(records.map(&:class).uniq).to eq([DuffelAPI::Resources::City])
      city = records.first

      expect(city.iata_code).to eq("ABI")
      expect(city.iata_country_code).to eq("US")
      expect(city.id).to eq("cit_abi_us")
      expect(city.name).to eq("Abilene")
    end

    it "exposes the API response" do
      records = client.cities.all.to_a
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
        client.cities.all(params: { limit: 33 }).
          to_a

        expect(first_response_stub).to have_been_requested
        expect(second_response_stub).to have_been_requested
      end
    end
  end

  describe "#get" do
    subject(:get_response) { client.cities.get(id) }

    let(:id) { "cit_lon_gb" }

    let!(:stub) do
      stub_request(:get, "https://api.duffel.com/air/cities/cit_lon_gb").
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    let(:response_body) { load_fixture("cities/show.json") }

    it "makes the expected request to the Duffel API" do
      get_response
      expect(stub).to have_been_requested
    end

    it "returns an Airport resource" do
      expect(get_response).to be_a(DuffelAPI::Resources::City)

      expect(get_response.iata_code).to eq("LON")
      expect(get_response.iata_country_code).to eq("GB")
      expect(get_response.id).to eq("cit_lon_gb")
      expect(get_response.name).to eq("London")
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
