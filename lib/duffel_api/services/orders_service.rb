# frozen_string_literal: true

module DuffelAPI
  module Services
    class OrdersService < BaseService
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

      def list(options = {})
        path = "/air/orders"

        response = make_request(:get, path, options)

        ListResponse.new(
          response: response,
          unenveloped_body: unenvelope_body(response.parsed_body),
          resource_class: Resources::Order,
        )
      end

      def all(options = {})
        Paginator.new(
          service: self,
          options: options,
        ).enumerator
      end

      def get(id, options = {})
        path = substitute_url_pattern("/air/orders/:id", "id" => id)

        response = make_request(:get, path, options)

        return if response.raw_body.nil?

        Resources::Order.new(unenvelope_body(response.parsed_body), response)
      end
    end
  end
end
