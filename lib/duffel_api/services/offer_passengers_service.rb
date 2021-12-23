# frozen_string_literal: true

module DuffelAPI
  module Services
    class OfferPassengersService < BaseService
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
