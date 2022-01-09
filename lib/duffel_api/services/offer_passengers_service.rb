# frozen_string_literal: true

module DuffelAPI
  module Services
    class OfferPassengersService < BaseService
      # Updates an offer passenger, based on the offer ID and passenger ID
      #
      # @param offer_id [String]
      # @param passenger_id [String]
      # @option [required, Hash] :params the payload for updating the passenger
      # @return [Resources::OfferPassenger]
      # @raise [Errors::Error] when the Duffel API returns an error
      def update(offer_id, passenger_id, options = {})
        path = substitute_url_pattern(
          "/air/offers/:offer_id/passengers/:passenger_id",
          "offer_id" => offer_id,
          "passenger_id" => passenger_id,
        )

        params = options.delete(:params) || {}
        options[:params] = {}
        options[:params]["data"] = params

        begin
          response = make_request(:patch, path, options)

          # Response doesn't raise any errors until #body is called
          response.tap(&:raw_body)
        end

        return if response.raw_body.nil?

        Resources::OfferPassenger.new(unenvelope_body(response.parsed_body), response)
      end
    end
  end
end
