# frozen_string_literal: true

module DuffelAPI
  module Services
    class SeatMapsService < BaseService
      def list(options = {})
        path = "/air/seat_maps"

        response = make_request(:get, path, options)

        ListResponse.new(
          response: response,
          unenveloped_body: unenvelope_body(response.parsed_body),
          resource_class: Resources::SeatMap,
        )
      end
    end
  end
end
