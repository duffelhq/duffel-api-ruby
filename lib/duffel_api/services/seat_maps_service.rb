# frozen_string_literal: true

module DuffelAPI
  module Services
    class SeatMapsService < BaseService
      # Lists all seat maps for an offer. This data is __not__ paginated.
      #
      # @option [Hash] :params Parameters to include in the HTTP querystring, including
      #   any filters
      # @return [ListResponse]
      # @raise [Errors::Error] when the Duffel API returns an error
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
