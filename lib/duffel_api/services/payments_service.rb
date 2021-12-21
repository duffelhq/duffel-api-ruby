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
          response.tap(&:raw_body)
        end

        return if response.raw_body.nil?

        Resources::Payment.new(unenvelope_body(response.parsed_body), response)
      end
    end
  end
end
