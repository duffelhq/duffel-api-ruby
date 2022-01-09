# frozen_string_literal: true

module DuffelAPI
  # A client for accessing the Duffel API, configured with a provided access token and
  # base URL, which provides access to API services
  class Client
    API_VERSION = "beta"

    # Sets up the client with your access token
    #
    # @param access_token [String] A test or live mode access token
    # @param base_url [String] The URL of the Duffel API
    # @return [Client]
    def initialize(access_token:, base_url: "https://api.duffel.com")
      @api_service = APIService.new(base_url, access_token, **default_options)
    end

    # @return [Services::AircraftService]
    def aircraft
      @aircraft ||= Services::AircraftService.new(@api_service)
    end

    # @return [Services::AirlinesService]
    def airlines
      @airlines ||= Services::AirlinesService.new(@api_service)
    end

    # @return [Services::AirportsService]
    def airports
      @airports ||= Services::AirportsService.new(@api_service)
    end

    # @return [Services::OfferPassengersService]
    def offer_passengers
      @offer_passengers ||= Services::OfferPassengersService.new(@api_service)
    end

    # @return [Services::OfferRequestsService]
    def offer_requests
      @offer_requests ||= Services::OfferRequestsService.new(@api_service)
    end

    # @return [Services::OffersService]
    def offers
      @offers ||= Services::OffersService.new(@api_service)
    end

    # @return [Services::OrderCancellationsService]
    def order_cancellations
      @order_cancellations ||= Services::OrderCancellationsService.new(@api_service)
    end

    # @return [Services::OrderChangeOffersService]
    def order_change_offers
      @order_change_offers ||= Services::OrderChangeOffersService.new(@api_service)
    end

    # @return [Services::OrderChangeRequestsService]
    def order_change_requests
      @order_change_requests ||= Services::OrderChangeRequestsService.new(@api_service)
    end

    # @return [Services::OrderChangesService]
    def order_changes
      @order_changes ||= Services::OrderChangesService.new(@api_service)
    end

    # @return [Services::OrdersService]
    def orders
      @orders ||= Services::OrdersService.new(@api_service)
    end

    # @return [Services::PaymentIntentsService]
    def payment_intents
      @payment_intents ||= Services::PaymentIntentsService.new(@api_service)
    end

    # @return [Services::PaymentsService]
    def payments
      @payments ||= Services::PaymentsService.new(@api_service)
    end

    # @return [Services::RefundsService]
    def refunds
      @refunds ||= Services::RefundsService.new(@api_service)
    end

    # @return [Services::SeatMapsService]
    def seat_maps
      @seat_maps ||= Services::SeatMapsService.new(@api_service)
    end

    # @return [Services::WebhooksService]
    def webhooks
      @webhooks ||= Services::WebhooksService.new(@api_service)
    end

    private

    def default_options
      {
        default_headers: {
          "Duffel-Version" => API_VERSION,
          "User-Agent" => "Duffel/#{API_VERSION} duffel_api_ruby/#{DuffelAPI::VERSION}",
          "Content-Type" => "application/json",
        },
      }
    end
  end
end
