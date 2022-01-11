# frozen_string_literal: true

module DuffelAPI
  module Services
    class OrderChangesService < BaseService
      # Creates an order chnage
      #
      # @option [required, Hash] :params the payload for creating the order change
      # @return [Resources::OrderChange]
      # @raise [Errors::Error] when the Duffel API returns an error
      def create(options = {})
        path = "/air/order_changes"

        params = options.delete(:params) || {}
        options[:params] = {}
        options[:params]["data"] = params

        begin
          response = make_request(:post, path, options)

          # Response doesn't raise any errors until #body is called
          response.tap(&:raw_body)
        end

        return if response.raw_body.nil?

        Resources::OrderChange.new(unenvelope_body(response.parsed_body), response)
      end

      # Confirms an order change by ID, passing across extra data required for
      #   confirmation
      #
      # @param id [String]
      # @option [required, Hash] :params
      # @return [Resources::OrderChange] the payload for confirming the order change
      # @raise [Errors::Error] when the Duffel API returns an error
      def confirm(id, options = {})
        path = substitute_url_pattern("/air/order_changes/:id/actions/confirm",
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

        Resources::OrderChange.new(unenvelope_body(response.parsed_body), response)
      end

      # Retrieves a single order change by ID
      #
      # @param id [String]
      # @return [Resources::OrderChange]
      # @raise [Errors::Error] when the Duffel API returns an error
      def get(id, options = {})
        path = substitute_url_pattern("/air/order_changes/:id", "id" => id)

        response = make_request(:get, path, options)

        return if response.raw_body.nil?

        Resources::OrderChange.new(unenvelope_body(response.parsed_body), response)
      end
    end
  end
end
