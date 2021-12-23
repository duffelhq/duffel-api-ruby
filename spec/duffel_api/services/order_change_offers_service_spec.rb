# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Services::OrderChangeOffersService do
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
      client.order_change_offers.
        list(params: { order_change_request_id: "ocr_0000AEdPRxCTitEvxq8Oum" })
    end

    let(:response_body) { load_fixture("order_change_offers/list.json") }

    let!(:stub) do
      stub_request(:get, "https://api.duffel.com/air/order_change_offers").
        with(query: { "order_change_request_id" => "ocr_0000AEdPRxCTitEvxq8Oum" }).
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    it "makes the expected request to the Duffel API" do
      get_list_response
      expect(stub).to have_been_requested
    end

    it "exposes valid OrderChangeOffer resources" do
      expect(get_list_response.records.map(&:class).uniq).
        to eq([DuffelAPI::Resources::OrderChangeOffer])

      order_change_offer = get_list_response.records.first

      expect(order_change_offer.change_total_amount).to eq("125.00")
      expect(order_change_offer.change_total_currency).to eq("GBP")
      expect(order_change_offer.created_at).to eq("2021-12-21T16:51:06.650804Z")
      expect(order_change_offer.expires_at).to eq("2021-12-24T16:51:06Z")
      expect(order_change_offer.id).to eq("oco_0000AEdPRxDtdcNG2EnX7o")
      expect(order_change_offer.live_mode).to be(false)
      expect(order_change_offer.new_total_amount).to eq("1067.79")
      expect(order_change_offer.new_total_currency).to eq("GBP")
      expect(order_change_offer.order_change_id).to be_nil
      expect(order_change_offer.penalty_total_amount).to eq("25.00")
      expect(order_change_offer.penalty_total_currency).to eq("GBP")
      expect(order_change_offer.refund_to).to eq("original_form_of_payment")
      expect(order_change_offer.slices.length).to eq(2)
      expect(order_change_offer.updated_at).to eq("2021-12-21T16:51:06.650804Z")
    end

    it "exposes the cursors for before and after" do
      expect(get_list_response.before).to eq(nil)
      expect(get_list_response.after).to eq("g3QAAAABZAACaWRtAAAAGm9mZl8wMDAwQUVkR1Jra" \
                                            "2lUVHpOVHdiZGdj")
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
      stub_request(:get, "https://api.duffel.com/air/order_change_offers").
        with(query: { "order_change_request_id" => "ocr_0000AEdPRxCTitEvxq8Oum" }).
        to_return(
          body: first_page_response_body,
          headers: response_headers,
        )
    end

    let(:first_page_response_body) { load_fixture("order_change_offers/list.json") }

    let(:last_page_response_body) do
      convert_list_response_to_last_page(first_page_response_body)
    end

    let!(:second_response_stub) do
      stub_request(:get, "https://api.duffel.com/air/order_change_offers").
        with(query: { "after" => "g3QAAAABZAACaWRtAAAAGm9mZl8wMDAwQUVkR1Jra2lUVHpOVHdi" \
                                 "ZGdj",
                      "order_change_request_id" => "ocr_0000AEdPRxCTitEvxq8Oum" }).
        to_return(
          body: last_page_response_body,
          headers: response_headers,
        )
    end

    it "automatically makes the extra requests to load all the pages" do
      expect(
        client.order_change_offers.
          all(params: { order_change_request_id: "ocr_0000AEdPRxCTitEvxq8Oum" }).
          to_a.
          length,
      ).to eq(4)
      expect(first_response_stub).to have_been_requested
      expect(second_response_stub).to have_been_requested
    end

    it "exposes valid OrderChangeOffer resources" do
      records = client.order_change_offers.
        all(params: { order_change_request_id: "ocr_0000AEdPRxCTitEvxq8Oum" }).to_a
      expect(records.map(&:class).uniq).to eq([DuffelAPI::Resources::OrderChangeOffer])
      order_change_offer = records.first

      expect(order_change_offer.change_total_amount).to eq("125.00")
      expect(order_change_offer.change_total_currency).to eq("GBP")
      expect(order_change_offer.created_at).to eq("2021-12-21T16:51:06.650804Z")
      expect(order_change_offer.expires_at).to eq("2021-12-24T16:51:06Z")
      expect(order_change_offer.id).to eq("oco_0000AEdPRxDtdcNG2EnX7o")
      expect(order_change_offer.live_mode).to be(false)
      expect(order_change_offer.new_total_amount).to eq("1067.79")
      expect(order_change_offer.new_total_currency).to eq("GBP")
      expect(order_change_offer.order_change_id).to be_nil
      expect(order_change_offer.penalty_total_amount).to eq("25.00")
      expect(order_change_offer.penalty_total_currency).to eq("GBP")
      expect(order_change_offer.refund_to).to eq("original_form_of_payment")
      expect(order_change_offer.slices.length).to eq(2)
      expect(order_change_offer.updated_at).to eq("2021-12-21T16:51:06.650804Z")
    end

    it "exposes the API response on the resources" do
      records = client.order_change_offers.
        all(params: { order_change_request_id: "ocr_0000AEdPRxCTitEvxq8Oum" })
      api_response = records.first.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(200)
    end
  end

  describe "#get" do
    subject(:get_response) { client.order_change_offers.get(id) }

    let(:id) { "oco_0000AEdPRxDtdcNG2EnX7o" }

    let!(:stub) do
      stub_request(:get, "https://api.duffel.com/air/order_change_offers/oco_0000AEdPRxDtdcNG2EnX7o").
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    let(:response_body) { load_fixture("order_change_offers/show.json") }

    it "makes the expected request to the Duffel API" do
      get_response
      expect(stub).to have_been_requested
    end

    it "returns an OrderChangeOffer resource" do
      order_change_offer = get_response

      expect(order_change_offer).to be_a(DuffelAPI::Resources::OrderChangeOffer)

      expect(order_change_offer.change_total_amount).to eq("125.00")
      expect(order_change_offer.change_total_currency).to eq("GBP")
      expect(order_change_offer.created_at).to eq("2021-12-21T16:51:06.650804Z")
      expect(order_change_offer.expires_at).to eq("2021-12-24T16:51:06Z")
      expect(order_change_offer.id).to eq("oco_0000AEdPRxDtdcNG2EnX7o")
      expect(order_change_offer.live_mode).to be(false)
      expect(order_change_offer.new_total_amount).to eq("1067.79")
      expect(order_change_offer.new_total_currency).to eq("GBP")
      expect(order_change_offer.order_change_id).to be_nil
      expect(order_change_offer.penalty_total_amount).to eq("25.00")
      expect(order_change_offer.penalty_total_currency).to eq("GBP")
      expect(order_change_offer.refund_to).to eq("original_form_of_payment")
      expect(order_change_offer.slices.length).to eq(2)
      expect(order_change_offer.updated_at).to eq("2021-12-21T16:51:06.650804Z")
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
