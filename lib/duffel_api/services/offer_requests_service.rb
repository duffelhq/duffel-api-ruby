# frozen_string_literal: true

module DuffelAPI
  module Services
    class OfferRequestsService < BaseService
      # Creates an offer request
      #
      # @option [required, Hash] :params the payload for creating the offer request,
      #   including parameters to be sent in the querystring
      # @return [Resources::OfferRequest]
      # @raise [Errors::Error] when the Duffel API returns an error
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

      # Lists offer requests, returning a single page of results.
      #
      # @option [Hash] :params Parameters to include in the HTTP querystring, including
      #   any filters
      # @return [ListResponse]
      # @raise [Errors::Error] when the Duffel API returns an error
      def list(options = {})
        path = "/air/offer_requests"

        response = make_request(:get, path, options)

        ListResponse.new(
          response: response,
          unenveloped_body: unenvelope_body(response.parsed_body),
          resource_class: Resources::OfferRequest,
        )
      end

      # Returns an `Enumerator` which can automatically cycle through multiple
      # pages of `Resources;:OfferRequest`s
      #
      # @param options [Hash] options passed to `#list`, for example `:params` to
      #   send an HTTP querystring with filters
      # @return [Enumerator]
      # @raise [Errors::Error] when the Duffel API returns an error
      def all(options = {})
        Paginator.new(
          service: self,
          options: options,
        ).enumerator
      end

      # Retrieves a single offer request by ID
      #
      # @param id [String]
      # @return [Resources::OfferRequest]
      # @raise [Errors::Error] when the Duffel API returns an error
      def get(id, options = {})
        path = substitute_url_pattern("/air/offer_requests/:id", "id" => id)

        response = make_request(:get, path, options)

        return if response.raw_body.nil?

        Resources::OfferRequest.new(unenvelope_body(response.parsed_body), response)
      end
    end
  end
end
