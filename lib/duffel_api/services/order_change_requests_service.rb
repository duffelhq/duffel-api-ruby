# frozen_string_literal: true

module DuffelAPI
  module Services
    class OrderChangeRequestsService < BaseService
      # Creates an order change request
      #
      # @option [required, Hash] :params the payload for creating the order change
      #  request
      # @return [Resources::OrderChangeRequest]
      # @raise [Errors::Error] when the Duffel API returns an error
      def create(options = {})
        path = "/air/order_change_requests"

        params = options.delete(:params) || {}

        options[:params] = {}
        options[:params]["data"] = params

        begin
          response = make_request(:post, path, options)

          # Response doesn't raise any errors until #body is called
          response.tap(&:raw_body)
        end

        return if response.raw_body.nil?

        Resources::OrderChangeRequest.new(unenvelope_body(response.parsed_body), response)
      end

      # Retrieves a single order change request by ID
      #
      # @param id [String]
      # @return [Resources::OrderChangeRequest]
      # @raise [Errors::Error] when the Duffel API returns an error
      def get(id, options = {})
        path = substitute_url_pattern("/air/order_change_requests/:id", "id" => id)

        response = make_request(:get, path, options)

        return if response.raw_body.nil?

        Resources::OrderChangeRequest.new(unenvelope_body(response.parsed_body), response)
      end
    end
  end
end
