# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Services::OffersService do
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
    subject(:get_list_response) do
      client.offers.list(params: { offer_request_id: "orq_0000AEdGRPso4CyykxEIsa" })
    end

    let(:response_body) { load_fixture("offers/list.json") }

    let!(:stub) do
      stub_request(:get, "https://api.duffel.com/air/offers").
        with(query: { "offer_request_id" => "orq_0000AEdGRPso4CyykxEIsa" }).
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    it "makes the expected request to the Duffel API" do
      get_list_response
      expect(stub).to have_been_requested
    end

    it "exposes valid Offer resources" do
      expect(get_list_response.records.map(&:class).uniq).
        to eq([DuffelAPI::Resources::Offer])

      offer = get_list_response.records.first

      expect(offer.allowed_passenger_identity_document_types).to eq([])
      expect(offer.available_services).to be_nil
      expect(offer.base_amount).to eq("414.28")
      expect(offer.base_currency).to eq("GBP")
      expect(offer.conditions).to eq({
        "change_before_departure" => nil,
        "refund_before_departure" => nil,
      })
      expect(offer.created_at).to eq("2021-12-21T15:10:13.263399Z")
      expect(offer.expires_at).to eq("2021-12-21T15:25:13.167715Z")
      expect(offer.id).to eq("off_0000AEdGRhtp5AUUdJqMxo")
      expect(offer.live_mode).to be(false)
      expect(offer.owner).to eq({
        "iata_code" => "HR",
        "id" => "arl_00009VME7DCOaPRQvNhcMV",
        "name" => "Hahn Air",
      })
      expect(offer.passenger_identity_documents_required).to be(false)
      expect(offer.passengers).to eq([{
        "age" => nil,
        "family_name" => nil,
        "given_name" => nil,
        "id" => "pas_0000AEdGRPso4CyykxEIsc",
        "loyalty_programme_accounts" => [],
        "type" => "adult",
      }])
      expect(offer.payment_requirements).to eq({
        "payment_required_by" => nil,
        "price_guarantee_expires_at" => nil,
        "requires_instant_payment" => true,
      })
      expect(offer.slices.length).to eq(1)
      expect(offer.tax_amount).to eq("247.60")
      expect(offer.tax_currency).to eq("GBP")
      expect(offer.total_amount).to eq("661.88")
      expect(offer.total_currency).to eq("GBP")
      expect(offer.total_emissions_kg).to eq("312")
      expect(offer.updated_at).to eq("2021-12-21T15:10:13.263399Z")
    end

    it "exposes the cursors for before and after" do
      expect(get_list_response.before).to eq(nil)
      expect(get_list_response.after).to eq("g3QAAAABZAACaWRtAAAAGm9mZl8wMDAwQUVkR1J" \
                                            "ra2lUVHpOVHdiZGdj")
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
      stub_request(:get, "https://api.duffel.com/air/offers").
        with(query: { "offer_request_id" => "orq_0000AEdGRPso4CyykxEIsa" }).
        to_return(
          body: first_page_response_body,
          headers: response_headers,
        )
    end

    let(:first_page_response_body) { load_fixture("offers/list.json") }

    let(:last_page_response_body) do
      convert_list_response_to_last_page(first_page_response_body)
    end

    let!(:second_response_stub) do
      stub_request(:get, "https://api.duffel.com/air/offers").
        with(query: { "after" => "g3QAAAABZAACaWRtAAAAGm9mZl8wMDAwQUVkR1Jra2lUVHpOVHdi" \
                                 "ZGdj",
                      "offer_request_id" => "orq_0000AEdGRPso4CyykxEIsa" }).
        to_return(
          body: last_page_response_body,
          headers: response_headers,
        )
    end

    it "automatically makes the extra requests to load all the pages" do
      expect(
        client.offers.
          all(params: { offer_request_id: "orq_0000AEdGRPso4CyykxEIsa" }).
          to_a.
          length,
      ).to eq(100)
      expect(first_response_stub).to have_been_requested
      expect(second_response_stub).to have_been_requested
    end

    it "exposes valid Offer resources" do
      records = client.offers.
        all(params: { offer_request_id: "orq_0000AEdGRPso4CyykxEIsa" }).to_a
      expect(records.map(&:class).uniq).to eq([DuffelAPI::Resources::Offer])
      offer = records.first

      expect(offer.allowed_passenger_identity_document_types).to eq([])
      expect(offer.available_services).to be_nil
      expect(offer.base_amount).to eq("414.28")
      expect(offer.base_currency).to eq("GBP")
      expect(offer.conditions).to eq({
        "change_before_departure" => nil,
        "refund_before_departure" => nil,
      })
      expect(offer.created_at).to eq("2021-12-21T15:10:13.263399Z")
      expect(offer.expires_at).to eq("2021-12-21T15:25:13.167715Z")
      expect(offer.id).to eq("off_0000AEdGRhtp5AUUdJqMxo")
      expect(offer.live_mode).to be(false)
      expect(offer.owner).to eq({
        "iata_code" => "HR",
        "id" => "arl_00009VME7DCOaPRQvNhcMV",
        "name" => "Hahn Air",
      })
      expect(offer.passenger_identity_documents_required).to be(false)
      expect(offer.passengers).to eq([{
        "age" => nil,
        "family_name" => nil,
        "given_name" => nil,
        "id" => "pas_0000AEdGRPso4CyykxEIsc",
        "loyalty_programme_accounts" => [],
        "type" => "adult",
      }])
      expect(offer.payment_requirements).to eq({
        "payment_required_by" => nil,
        "price_guarantee_expires_at" => nil,
        "requires_instant_payment" => true,
      })
      expect(offer.slices.length).to eq(1)
      expect(offer.tax_amount).to eq("247.60")
      expect(offer.tax_currency).to eq("GBP")
      expect(offer.total_amount).to eq("661.88")
      expect(offer.total_currency).to eq("GBP")
      expect(offer.total_emissions_kg).to eq("312")
      expect(offer.updated_at).to eq("2021-12-21T15:10:13.263399Z")
    end

    it "exposes the API response on the resources" do
      records = client.offers.
        all(params: { offer_request_id: "orq_0000AEdGRPso4CyykxEIsa" }).to_a
      api_response = records.first.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(200)
    end
  end

  describe "#get" do
    subject(:get_response) { client.offers.get(id) }

    let(:id) { "off_0000AEdGRhtp5AUUdJqMxo" }

    let!(:stub) do
      stub_request(:get, "https://api.duffel.com/air/offers/off_0000AEdGRhtp5AUUdJqMxo").
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    let(:response_body) { load_fixture("offers/show.json") }

    it "makes the expected request to the Duffel API" do
      get_response
      expect(stub).to have_been_requested
    end

    it "returns an Offer resource" do
      offer = get_response

      expect(offer).to be_a(DuffelAPI::Resources::Offer)

      expect(offer.allowed_passenger_identity_document_types).to eq(["passport"])
      expect(offer.available_services).to eq([])
      expect(offer.base_amount).to eq("311.00")
      expect(offer.base_currency).to eq("GBP")
      expect(offer.conditions).to eq({
        "change_before_departure" => nil,
        "refund_before_departure" => nil,
      })
      expect(offer.created_at).to eq("2021-10-18T10:48:10.625784Z")
      expect(offer.expires_at).to eq("2021-10-18T11:18:23.000000Z")
      expect(offer.id).to eq("off_0000ACUEAwiy4LZKiaec5s")
      expect(offer.live_mode).to be(false)
      expect(offer.owner).to eq({
        "iata_code" => "AA",
        "id" => "arl_00009VME7DAGiJjwomhv32",
        "name" => "American Airlines",
      })
      expect(offer.passenger_identity_documents_required).to be(false)
      expect(offer.passengers).to eq([{
        "age" => nil,
        "family_name" => nil,
        "given_name" => nil,
        "id" => "pas_0000ACUEAjR7TOZFVTCfy6",
        "loyalty_programme_accounts" => [],
        "type" => "adult",
      }])
      expect(offer.payment_requirements).to eq({
        "payment_required_by" => "2021-10-19T22:59:00Z",
        "price_guarantee_expires_at" => "2021-10-19T22:59:00Z",
        "requires_instant_payment" => false,
      })
      expect(offer.slices.length).to eq(1)
      expect(offer.tax_amount).to eq("40.30")
      expect(offer.tax_currency).to eq("GBP")
      expect(offer.total_amount).to eq("351.30")
      expect(offer.total_currency).to eq("GBP")
      expect(offer.total_emissions_kg).to eq("116")
      expect(offer.updated_at).to eq("2021-10-18T10:48:24.571463Z")
    end

    it "exposes the API response" do
      api_response = get_response.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(200)
    end

    context "with parameters" do
      let!(:stub) do
        stub_request(:get, "https://api.duffel.com/air/offers/off_0000AEdGRhtp5AUUdJqMxo").
          with(query: { "return_available_services" => true })
        to_return(
          body: response_body,
          headers: response_headers,
        )
        it "makes the expected request to the Duffel API" do
          client.offers.get(id, params: { return_available_services: true })
          expect(stub).to have_been_requested
        end
      end
    end
  end
end
