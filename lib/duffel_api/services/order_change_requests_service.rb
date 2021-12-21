# frozen_string_literal: true

module DuffelAPI
  module Services
    class OrderChangeRequestsService < BaseService
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

      def get(id, options = {})
        path = substitute_url_pattern("/air/order_change_requests/:id", "id" => id)

        response = make_request(:get, path, options)

        return if response.raw_body.nil?

        Resources::OrderChangeRequest.new(unenvelope_body(response.parsed_body), response)
      end
    end
  end
end
