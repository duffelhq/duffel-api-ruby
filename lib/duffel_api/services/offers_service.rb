# frozen_string_literal: true

module DuffelAPI
  module Services
    class OffersService < BaseService
      # Lists offers, returning a single page of results.
      #
      # @option [required, Hash] :params Parameters to include in the HTTP querystring,
      #   including any filters
      # @return [ListResponse]
      # @raise [Errors::Error] when the Duffel API returns an error
      def list(options = {})
        path = "/air/offers"

        response = make_request(:get, path, options)

        ListResponse.new(
          response: response,
          unenveloped_body: unenvelope_body(response.parsed_body),
          resource_class: Resources::Offer,
        )
      end

      # Returns an `Enumerator` which can automatically cycle through multiple
      # pages of `Resources;:Offers`s
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

      # Retrieves a single offer by ID
      #
      # @param id [String]
      # @return [Resources::Offer]
      # @raise [Errors::Error] when the Duffel API returns an error
      def get(id, options = {})
        path = substitute_url_pattern("/air/offers/:id", "id" => id)

        response = make_request(:get, path, options)

        return if response.raw_body.nil?

        Resources::Offer.new(unenvelope_body(response.parsed_body), response)
      end
    end
  end
end
