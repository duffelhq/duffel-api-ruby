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
