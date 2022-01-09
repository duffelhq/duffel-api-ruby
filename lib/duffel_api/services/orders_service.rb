# frozen_string_literal: true

module DuffelAPI
  module Services
    class OrdersService < BaseService
      # Creates an order
      #
      # @option [required, Hash] :params the payload for creating the order
      # @return [Resources::Order]
      # @raise [Errors::Error] when the Duffel API returns an error
      def create(options = {})
        path = "/air/orders"

        params = options.delete(:params) || {}
        options[:params] = {}
        options[:params]["data"] = params

        begin
          response = make_request(:post, path, options)

          # Response doesn't raise any errors until #body is called
          response.tap(&:raw_body)
        end

        return if response.raw_body.nil?

        Resources::Order.new(unenvelope_body(response.parsed_body), response)
      end

      # Updates an order
      #
      # @option [required, Hash] :params the payload for updating the order
      # @return [Resources::Order]
      # @raise [Errors::Error] when the Duffel API returns an error
      def update(id, options = {})
        path = substitute_url_pattern("/air/orders/:id", "id" => id)

        params = options.delete(:params) || {}
        options[:params] = {}
        options[:params]["data"] = params

        begin
          response = make_request(:patch, path, options)

          # Response doesn't raise any errors until #body is called
          response.tap(&:raw_body)
        end

        return if response.raw_body.nil?

        Resources::Order.new(unenvelope_body(response.parsed_body), response)
      end

      # Lists orders, returning a single page of results.
      #
      # @option [Hash] :params Parameters to include in the HTTP querystring, including
      #   any filters
      # @return [ListResponse]
      # @raise [Errors::Error] when the Duffel API returns an error
      def list(options = {})
        path = "/air/orders"

        response = make_request(:get, path, options)

        ListResponse.new(
          response: response,
          unenveloped_body: unenvelope_body(response.parsed_body),
          resource_class: Resources::Order,
        )
      end

      # Returns an `Enumerator` which can automatically cycle through multiple
      # pages of `Resources;:Order`s
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

      # Retrieves a single order by ID
      #
      # @param id [String]
      # @return [Resources::Order]
      # @raise [Errors::Error] when the Duffel API returns an error
      def get(id, options = {})
        path = substitute_url_pattern("/air/orders/:id", "id" => id)

        response = make_request(:get, path, options)

        return if response.raw_body.nil?

        Resources::Order.new(unenvelope_body(response.parsed_body), response)
      end
    end
  end
end
