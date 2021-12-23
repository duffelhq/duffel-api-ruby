# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Services::OrdersService do
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
    subject(:post_create_response) { client.orders.create(params: params) }

    let(:params) do
      {
        selected_offers: [
          "off_0000AEdJFJfeGeVcAKMxRz",
        ],
        passengers: [
          {
            age: 25,
            given_name: "John",
            family_name: "Smith",
            born_on: "1995-05-05",
            title: "mr",
            gender: "m",
            email: "john.smith@example.com",
            phone_number: "+447964280250",
            id: "pas_0000AEdJFJSX3Q17VeEU0R",
          },
        ],
        payments: [
          {
            type: "balance",
            amount: "1016.15",
            currency: "GBP",
          },
        ],
      }
    end

    let(:response_body) { load_fixture("orders/show.json") }

    let!(:stub) do
      stub_request(:post, "https://api.duffel.com/air/orders").
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
      order = post_create_response

      expect(order).to be_a(DuffelAPI::Resources::Order)

      expect(order.base_amount).to eq("861.14")
      expect(order.base_currency).to eq("GBP")
      expect(order.booking_reference).to eq("GAIRBB")
      expect(order.cancelled_at).to be_nil
      expect(order.conditions).to eq({
        "change_before_departure" => { "allowed" => false, "penalty_amount" => nil,
                                       "penalty_currency" => nil },
        "refund_before_departure" => { "allowed" => true, "penalty_amount" => "170.00",
                                       "penalty_currency" => "GBP" },
      })
      expect(order.created_at).to eq("2021-12-21T15:41:42.765467Z")
      expect(order.documents).to eq([{ "type" => "electronic_ticket",
                                       "unique_identifier" => "1" }])
      expect(order.id).to eq("ord_0000AEdJFxag2IaNxbrlY1")
      expect(order.live_mode).to be(false)
      expect(order.metadata).to be_nil
      expect(order.owner).to eq({
        "iata_code" => "ZZ",
        "id" => "arl_00009VME7D6ivUu8dn35WK",
        "name" => "Duffel Airways",
      })
      expect(order.passengers).to eq([{ "born_on" => "1995-05-05",
                                        "family_name" => "Smith",
                                        "gender" => "m",
                                        "given_name" => "John",
                                        "id" => "pas_0000AEdJFJSX3Q17VeEU0R",
                                        "infant_passenger_id" => nil,
                                        "title" => "mr",
                                        "type" => "adult" }])
      expect(order.payment_status).to eq({
        "awaiting_payment" => false,
        "payment_required_by" => nil,
        "price_guarantee_expires_at" => nil,
      })
      expect(order.services).to eq([])
      expect(order.slices.length).to eq(2)
      expect(order.synced_at).to eq("2021-12-21T15:41:42Z")
      expect(order.tax_amount).to eq("155.01")
      expect(order.tax_currency).to eq("GBP")
      expect(order.total_amount).to eq("1016.15")
      expect(order.total_currency).to eq("GBP")
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

  describe "#update" do
    subject(:update_response) do
      client.orders.update("ord_0000AEdJFxag2IaNxbrlY1", params: params)
    end

    let(:params) do
      {
        metadata: {
          payment_intent_id: "dummy",
        },
      }
    end

    let(:response_body) { load_fixture("orders/show.json") }

    let!(:stub) do
      stub_request(:patch, "https://api.duffel.com/air/orders/ord_0000AEdJFxag2IaNxbrlY1").
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
      update_response
      expect(stub).to have_been_requested
    end

    it "returns the updated resource" do
      order = update_response

      expect(order).to be_a(DuffelAPI::Resources::Order)

      expect(order.base_amount).to eq("861.14")
      expect(order.base_currency).to eq("GBP")
      expect(order.booking_reference).to eq("GAIRBB")
      expect(order.cancelled_at).to be_nil
      expect(order.conditions).to eq({
        "change_before_departure" => { "allowed" => false, "penalty_amount" => nil,
                                       "penalty_currency" => nil },
        "refund_before_departure" => { "allowed" => true, "penalty_amount" => "170.00",
                                       "penalty_currency" => "GBP" },
      })
      expect(order.created_at).to eq("2021-12-21T15:41:42.765467Z")
      expect(order.documents).to eq([{ "type" => "electronic_ticket",
                                       "unique_identifier" => "1" }])
      expect(order.id).to eq("ord_0000AEdJFxag2IaNxbrlY1")
      expect(order.live_mode).to be(false)
      expect(order.metadata).to be_nil
      expect(order.owner).to eq({
        "iata_code" => "ZZ",
        "id" => "arl_00009VME7D6ivUu8dn35WK",
        "name" => "Duffel Airways",
      })
      expect(order.passengers).to eq([{ "born_on" => "1995-05-05",
                                        "family_name" => "Smith",
                                        "gender" => "m",
                                        "given_name" => "John",
                                        "id" => "pas_0000AEdJFJSX3Q17VeEU0R",
                                        "infant_passenger_id" => nil,
                                        "title" => "mr",
                                        "type" => "adult" }])
      expect(order.payment_status).to eq({
        "awaiting_payment" => false,
        "payment_required_by" => nil,
        "price_guarantee_expires_at" => nil,
      })
      expect(order.services).to eq([])
      expect(order.slices.length).to eq(2)
      expect(order.synced_at).to eq("2021-12-21T15:41:42Z")
      expect(order.tax_amount).to eq("155.01")
      expect(order.tax_currency).to eq("GBP")
      expect(order.total_amount).to eq("1016.15")
      expect(order.total_currency).to eq("GBP")
    end

    it "exposes the API response" do
      api_response = update_response.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(200)
    end
  end

  describe "#list" do
    describe "with no filters" do
      subject(:get_list_response) { client.orders.list }

      let(:response_body) { load_fixture("orders/list.json") }

      let!(:stub) do
        stub_request(:get, "https://api.duffel.com/air/orders").to_return(
          body: response_body,
          headers: response_headers,
        )
      end

      it "makes the expected request to the Duffel API" do
        get_list_response
        expect(stub).to have_been_requested
      end

      it "exposes valid Order resources" do
        expect(get_list_response.records.map(&:class).uniq).
          to eq([DuffelAPI::Resources::Order])

        order = get_list_response.records.first

        expect(order.base_amount).to eq("861.14")
        expect(order.base_currency).to eq("GBP")
        expect(order.booking_reference).to eq("GAIRBB")
        expect(order.cancelled_at).to be_nil
        expect(order.conditions).to eq({
          "change_before_departure" => { "allowed" => false, "penalty_amount" => nil,
                                         "penalty_currency" => nil },
          "refund_before_departure" => { "allowed" => true, "penalty_amount" => "170.00",
                                         "penalty_currency" => "GBP" },
        })
        expect(order.created_at).to eq("2021-12-21T15:41:42.765467Z")
        expect(order.documents).to eq([{ "type" => "electronic_ticket",
                                         "unique_identifier" => "1" }])
        expect(order.id).to eq("ord_0000AEdJFxag2IaNxbrlY1")
        expect(order.live_mode).to be(false)
        expect(order.metadata).to be_nil
        expect(order.owner).to eq({
          "iata_code" => "ZZ",
          "id" => "arl_00009VME7D6ivUu8dn35WK",
          "name" => "Duffel Airways",
        })
        expect(order.passengers).to eq([{ "born_on" => "1995-05-05",
                                          "family_name" => "Smith",
                                          "gender" => "m",
                                          "given_name" => "John",
                                          "id" => "pas_0000AEdJFJSX3Q17VeEU0R",
                                          "infant_passenger_id" => nil,
                                          "title" => "mr",
                                          "type" => "adult" }])
        expect(order.payment_status).to eq({
          "awaiting_payment" => false,
          "payment_required_by" => nil,
          "price_guarantee_expires_at" => nil,
        })
        expect(order.services).to eq([])
        expect(order.slices.length).to eq(2)
        expect(order.synced_at).to eq("2021-12-21T15:41:42Z")
        expect(order.tax_amount).to eq("155.01")
        expect(order.tax_currency).to eq("GBP")
        expect(order.total_amount).to eq("1016.15")
        expect(order.total_currency).to eq("GBP")
      end

      it "exposes the cursors for before and after" do
        expect(get_list_response.before).to eq(nil)
        expect(get_list_response.after).to eq("g3QAAAACZAACaWRtAAAAGm9yZF8wMDAwQUQ0MEZ" \
                                              "PQW1STHloRTNLWGo2ZAALaW5zZXJ0ZWRfYXR0AA" \
                                              "AADWQACl9fc3RydWN0X19kAA9FbGl4aXIuRGF0Z" \
                                              "VRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxl" \
                                              "bmRhci5JU09kAANkYXlhBGQABGhvdXJhEWQAC21" \
                                              "pY3Jvc2Vjb25kaAJiAAA5HGEGZAAGbWludXRlYQ" \
                                              "FkAAVtb250aGELZAAGc2Vjb25kYStkAApzdGRfb" \
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
      subject(:get_list_response) { client.orders.list(params: { limit: 200 }) }

      let(:response_body) { load_fixture("orders/list.json") }

      let!(:stub) do
        stub_request(:get, "https://api.duffel.com/air/orders").
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
      stub_request(:get, "https://api.duffel.com/air/orders").to_return(
        body: first_page_response_body,
        headers: response_headers,
      )
    end

    let(:first_page_response_body) { load_fixture("orders/list.json") }

    let(:last_page_response_body) do
      convert_list_response_to_last_page(first_page_response_body)
    end

    let!(:second_response_stub) do
      stub_request(:get, "https://api.duffel.com/air/orders").
        with(query: { "after" => "g3QAAAACZAACaWRtAAAAGm9yZF8wMDAwQUQ0MEZ" \
                                 "PQW1STHloRTNLWGo2ZAALaW5zZXJ0ZWRfYXR0AA" \
                                 "AADWQACl9fc3RydWN0X19kAA9FbGl4aXIuRGF0Z" \
                                 "VRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxl" \
                                 "bmRhci5JU09kAANkYXlhBGQABGhvdXJhEWQAC21" \
                                 "pY3Jvc2Vjb25kaAJiAAA5HGEGZAAGbWludXRlYQ" \
                                 "FkAAVtb250aGELZAAGc2Vjb25kYStkAApzdGRfb" \
                                 "2Zmc2V0YQBkAAl0aW1lX3pvbmVtAAAAB0V0Yy9V" \
                                 "VENkAAp1dGNfb2Zmc2V0YQBkAAR5ZWFyYgAAB-V" \
                                 "kAAl6b25lX2FiYnJtAAAAA1VUQw==" }).
        to_return(
          body: last_page_response_body,
          headers: response_headers,
        )
    end

    it "automatically makes the extra requests to load all the pages" do
      expect(client.orders.all.to_a.length).to eq(100)
      expect(first_response_stub).to have_been_requested
      expect(second_response_stub).to have_been_requested
    end

    it "exposes valid Order resources" do
      records = client.orders.all.to_a
      expect(records.map(&:class).uniq).to eq([DuffelAPI::Resources::Order])
      order = records.first

      expect(order.base_amount).to eq("861.14")
      expect(order.base_currency).to eq("GBP")
      expect(order.booking_reference).to eq("GAIRBB")
      expect(order.cancelled_at).to be_nil
      expect(order.conditions).to eq({
        "change_before_departure" => { "allowed" => false, "penalty_amount" => nil,
                                       "penalty_currency" => nil },
        "refund_before_departure" => { "allowed" => true, "penalty_amount" => "170.00",
                                       "penalty_currency" => "GBP" },
      })
      expect(order.created_at).to eq("2021-12-21T15:41:42.765467Z")
      expect(order.documents).to eq([{ "type" => "electronic_ticket",
                                       "unique_identifier" => "1" }])
      expect(order.id).to eq("ord_0000AEdJFxag2IaNxbrlY1")
      expect(order.live_mode).to be(false)
      expect(order.metadata).to be_nil
      expect(order.owner).to eq({
        "iata_code" => "ZZ",
        "id" => "arl_00009VME7D6ivUu8dn35WK",
        "name" => "Duffel Airways",
      })
      expect(order.passengers).to eq([{ "born_on" => "1995-05-05",
                                        "family_name" => "Smith",
                                        "gender" => "m",
                                        "given_name" => "John",
                                        "id" => "pas_0000AEdJFJSX3Q17VeEU0R",
                                        "infant_passenger_id" => nil,
                                        "title" => "mr",
                                        "type" => "adult" }])
      expect(order.payment_status).to eq({
        "awaiting_payment" => false,
        "payment_required_by" => nil,
        "price_guarantee_expires_at" => nil,
      })
      expect(order.services).to eq([])
      expect(order.slices.length).to eq(2)
      expect(order.synced_at).to eq("2021-12-21T15:41:42Z")
      expect(order.tax_amount).to eq("155.01")
      expect(order.tax_currency).to eq("GBP")
      expect(order.total_amount).to eq("1016.15")
      expect(order.total_currency).to eq("GBP")
    end

    it "exposes the API response on the resources" do
      records = client.orders.all
      api_response = records.first.api_response

      expect(api_response).to be_a(DuffelAPI::APIResponse)

      expect(api_response.body).to be_a(String)
      expect(api_response.headers).to eq(response_headers)
      expect(api_response.request_id).to eq(response_headers["x-request-id"])
      expect(api_response.status_code).to eq(200)
    end
  end

  describe "#get" do
    subject(:get_response) { client.orders.get(id) }

    let(:id) { "ord_0000AEdJFxag2IaNxbrlY1" }

    let!(:stub) do
      stub_request(:get, "https://api.duffel.com/air/orders/ord_0000AEdJFxag2IaNxbrlY1").
        to_return(
          body: response_body,
          headers: response_headers,
        )
    end

    let(:response_body) { load_fixture("orders/show.json") }

    it "makes the expected request to the Duffel API" do
      get_response
      expect(stub).to have_been_requested
    end

    it "returns an Order resource" do
      order = get_response

      expect(order).to be_a(DuffelAPI::Resources::Order)

      expect(order.base_amount).to eq("861.14")
      expect(order.base_currency).to eq("GBP")
      expect(order.booking_reference).to eq("GAIRBB")
      expect(order.cancelled_at).to be_nil
      expect(order.conditions).to eq({
        "change_before_departure" => { "allowed" => false, "penalty_amount" => nil,
                                       "penalty_currency" => nil },
        "refund_before_departure" => { "allowed" => true, "penalty_amount" => "170.00",
                                       "penalty_currency" => "GBP" },
      })
      expect(order.created_at).to eq("2021-12-21T15:41:42.765467Z")
      expect(order.documents).to eq([{ "type" => "electronic_ticket",
                                       "unique_identifier" => "1" }])
      expect(order.id).to eq("ord_0000AEdJFxag2IaNxbrlY1")
      expect(order.live_mode).to be(false)
      expect(order.metadata).to be_nil
      expect(order.owner).to eq({
        "iata_code" => "ZZ",
        "id" => "arl_00009VME7D6ivUu8dn35WK",
        "name" => "Duffel Airways",
      })
      expect(order.passengers).to eq([{ "born_on" => "1995-05-05",
                                        "family_name" => "Smith",
                                        "gender" => "m",
                                        "given_name" => "John",
                                        "id" => "pas_0000AEdJFJSX3Q17VeEU0R",
                                        "infant_passenger_id" => nil,
                                        "title" => "mr",
                                        "type" => "adult" }])
      expect(order.payment_status).to eq({
        "awaiting_payment" => false,
        "payment_required_by" => nil,
        "price_guarantee_expires_at" => nil,
      })
      expect(order.services).to eq([])
      expect(order.slices.length).to eq(2)
      expect(order.synced_at).to eq("2021-12-21T15:41:42Z")
      expect(order.tax_amount).to eq("155.01")
      expect(order.tax_currency).to eq("GBP")
      expect(order.total_amount).to eq("1016.15")
      expect(order.total_currency).to eq("GBP")
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
