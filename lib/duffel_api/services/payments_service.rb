# frozen_string_literal: true

module DuffelAPI
  module Services
    class PaymentsService < BaseService
      def create(options = {})
        path = "/air/payments"

        params = options.delete(:params) || {}
        options[:params] = {}
        options[:params]["data"] = params

        begin
          response = make_request(:post, path, options)

          # Response doesn't raise any errors until #body is called
          response.tap(&:body)
        end

        return if response.body.nil?

        Resources::Payment.new(unenvelope_body(response.body), response)
      end
    end
  end
end
