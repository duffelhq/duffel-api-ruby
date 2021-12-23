# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Services::OfferPassengersService do
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

  describe "#update" do
    subject(:patch_update_response) do
      client.offer_passengers.update(offer_id, passenger_id, params: params)
    end

    let(:offer_id) { "off_0000AEdGRhtp5AUUdJqMxo" }
    let(:passenger_id) { "pas_0000AEatBgILqTHcCDhDmr" }

    let(:params) do
      {
        given_name: "Tim",
        family_name: "Rogers",
        loyalty_programme_accounts: [
          {
            account_number: "12901014",
            airline_iata_code: "BA",
          },
        ],
      }
    end

    let(:response_body) { load_fixture("offer_passengers/show.json") }

    let!(:stub) do
      stub_request(:patch, "https://api.duffel.com/air/offers/#{offer_id}/passengers/#{passenger_id}").
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
      patch_update_response
      expect(stub).to have_been_requested
    end

    it "returns the updated resource" do
      offer_passenger = patch_update_response

      expect(offer_passenger).to be_a(DuffelAPI::Resources::OfferPassenger)

      expect(offer_passenger.type).to eq("adult")
      expect(offer_passenger.loyalty_programme_accounts).to eq([{
        "account_number" => "12901014", "airline_iata_code" => "BA"
      }])
      expect(offer_passenger.id).to eq(passenger_id)
      expect(offer_passenger.given_name).to eq("Tim")
      expect(offer_passenger.family_name).to eq("Rogers")
      expect(offer_passenger.age).to eq(28)
    end

    it "exposes the API response" do
      api_response = patch_update_response.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(200)
    end
  end
end
