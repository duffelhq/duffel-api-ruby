# frozen_string_literal: true

module DuffelAPI
  class Client
    API_VERSION = "beta"

    def initialize(access_token:, base_url: "https://api.duffel.com")
      @api_service = APIService.new(base_url, access_token, default_options)
    end

    def aircraft
      @aircraft ||= Services::AircraftService.new(@api_service)
    end

    def airlines
      @airlines ||= Services::AirlinesService.new(@api_service)
    end

    def airports
      @airports ||= Services::AirportsService.new(@api_service)
    end

    def offer_requests
      @offer_requests ||= Services::OfferRequestsService.new(@api_service)
    end

    def offers
      @offers ||= Services::OffersService.new(@api_service)
    end

    def order_cancellations
      @order_cancellations ||= Services::OrderCancellationsService.new(@api_service)
    end

    def order_change_offers
      @order_change_offers ||= Services::OrderChangeOffersService.new(@api_service)
    end

    def order_change_requests
      @order_change_requests ||= Services::OrderChangeRequestsService.new(@api_service)
    end

    def orders
      @orders ||= Services::OrdersService.new(@api_service)
    end

    def payments
      @payments ||= Services::PaymentsService.new(@api_service)
    end

    def seat_maps
      @seat_maps ||= Services::SeatMapsService.new(@api_service)
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
