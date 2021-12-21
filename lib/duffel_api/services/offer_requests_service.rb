# frozen_string_literal: true

module DuffelAPI
  module Services
    class OfferRequestsService < BaseService
      def create(options = {})
        path = "/air/offer_requests"

        params = options.delete(:params) || {}

        # The "Create offer request" API expects a JSON body and can also accept the
        # `return_offers` query parameter. No other endpoints in the Duffel API allow
        # both. To avoid making the client library interface confusing, we get the client
        # to pass this value in along with the body params, and we know to move it into
        # the querystring.
        return_offers = params.delete(:return_offers)

        unless return_offers.nil?
          options[:query_params] = { return_offers: return_offers }
        end

        options[:params] = {}
        options[:params]["data"] = params

        begin
          response = make_request(:post, path, options)

          # Response doesn't raise any errors until #body is called
          response.tap(&:raw_body)
        end

        return if response.raw_body.nil?

        Resources::OfferRequest.new(unenvelope_body(response.parsed_body), response)
      end

      def list(options = {})
        path = "/air/offer_requests"

        response = make_request(:get, path, options)

        ListResponse.new(
          response: response,
          unenveloped_body: unenvelope_body(response.parsed_body),
          resource_class: Resources::OfferRequest,
        )
      end

      def all(options = {})
        Paginator.new(
          service: self,
          options: options,
        ).enumerator
      end

      def get(id, options = {})
        path = substitute_url_pattern("/air/offer_requests/:id", "id" => id)

        response = make_request(:get, path, options)

        return if response.raw_body.nil?

        Resources::OfferRequest.new(unenvelope_body(response.parsed_body), response)
      end
    end
  end
end
