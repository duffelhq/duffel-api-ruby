# frozen_string_literal: true

module DuffelAPI
  module Services
    class OrderCancellationsService < BaseService
      # Creates an order cancellation
      #
      # @option [required, Hash] :params the payload for creating the order cancellation
      # @return [Resources::OrderCancellation]
      # @raise [Errors::Error] when the Duffel API returns an error
      def create(options = {})
        path = "/air/order_cancellations"

        params = options.delete(:params) || {}
        options[:params] = {}
        options[:params]["data"] = params

        begin
          response = make_request(:post, path, options)

          # Response doesn't raise any errors until #body is called
          response.tap(&:raw_body)
        end

        return if response.raw_body.nil?

        Resources::OrderCancellation.new(unenvelope_body(response.parsed_body), response)
      end

      # Confirms an order cancellation by ID
      #
      # @param id [String]
      # @return [Resources::OrderCancellation]
      # @raise [Errors::Error] when the Duffel API returns an error
      def confirm(id, options = {})
        path = substitute_url_pattern("/air/order_cancellations/:id/actions/confirm",
                                      "id" => id)

        params = options.delete(:params) || {}
        options[:params] = {}
        options[:params]["data"] = params

        begin
          response = make_request(:post, path, options)

          # Response doesn't raise any errors until #body is called
          response.tap(&:raw_body)
        end

        return if response.raw_body.nil?

        Resources::OrderCancellation.new(unenvelope_body(response.parsed_body), response)
      end

      # Lists offers, returning a single page of results.
      #
      # @option [Hash] :params Parameters to include in the HTTP querystring, including
      #   any filters
      # @return [ListResponse]
      # @raise [Errors::Error] when the Duffel API returns an error
      def list(options = {})
        path = "/air/order_cancellations"

        response = make_request(:get, path, options)

        ListResponse.new(
          response: response,
          unenveloped_body: unenvelope_body(response.parsed_body),
          resource_class: Resources::OrderCancellation,
        )
      end

      # Returns an `Enumerator` which can automatically cycle through multiple
      # pages of `Resources;:OrderCancellation`s
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

      # Retrieves a single order cancellation by ID
      #
      # @param id [String]
      # @return [Resources::OrderCancellation]
      # @raise [Errors::Error] when the Duffel API returns an error
      def get(id, options = {})
        path = substitute_url_pattern("/air/order_cancellations/:id", "id" => id)

        response = make_request(:get, path, options)

        return if response.raw_body.nil?

        Resources::OrderCancellation.new(unenvelope_body(response.parsed_body), response)
      end
    end
  end
end
