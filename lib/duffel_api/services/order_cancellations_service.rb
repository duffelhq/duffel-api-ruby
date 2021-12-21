# frozen_string_literal: true

module DuffelAPI
  module Services
    class OrderCancellationsService < BaseService
      def create(options = {})
        path = "/air/order_cancellations"

        params = options.delete(:params) || {}
        options[:params] = {}
        options[:params]["data"] = params

        begin
          response = make_request(:post, path, options)

          # Response doesn't raise any errors until #body is called
          response.tap(&:body)
        end

        return if response.body.nil?

        Resources::OrderCancellation.new(unenvelope_body(response.body), response)
      end

      def confirm(id, options = {})
        path = substitute_url_pattern("/air/order_cancellations/:id/actions/confirm",
                                      "id" => id)

        params = options.delete(:params) || {}
        options[:params] = {}
        options[:params]["data"] = params

        begin
          response = make_request(:post, path, options)

          # Response doesn't raise any errors until #body is called
          response.tap(&:body)
        end

        return if response.body.nil?

        Resources::OrderCancellation.new(unenvelope_body(response.body), response)
      end

      def list(options = {})
        path = "/air/order_cancellations"

        response = make_request(:get, path, options)

        ListResponse.new(
          response: response,
          unenveloped_body: unenvelope_body(response.body),
          resource_class: Resources::OrderCancellation,
        )
      end

      def all(options = {})
        Paginator.new(
          service: self,
          options: options,
        ).enumerator
      end

      def get(id, options = {})
        path = substitute_url_pattern("/air/order_cancellations/:id", "id" => id)

        response = make_request(:get, path, options)

        return if response.body.nil?

        Resources::OrderCancellation.new(unenvelope_body(response.body), response)
      end
    end
  end
end
