# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class PaymentIntent < BaseResource
      attr_reader :amount
      attr_reader :card_country_code
      attr_reader :card_last_four_digits
      attr_reader :card_network
      attr_reader :client_token
      attr_reader :confirmed_at
      attr_reader :created_at
      attr_reader :currency
      attr_reader :fees_amount
      attr_reader :fees_currency
      attr_reader :id
      attr_reader :live_mode
      attr_reader :net_amount
      attr_reader :net_currency
      attr_reader :refunds
      attr_reader :status
      attr_reader :updated_at

      def initialize(object, response = nil)
        @object = object

        @amount = object["amount"]
        @card_country_code = object["card_country_code"]
        @card_last_four_digits = object["card_last_four_digits"]
        @card_network = object["card_network"]
        @client_token = object["client_token"]
        @confirmed_at = object["confirmed_at"]
        @created_at = object["created_at"]
        @currency = object["currency"]
        @fees_amount = object["fees_amount"]
        @fees_currency = object["fees_currency"]
        @id = object["id"]
        @live_mode = object["live_mode"]
        @net_amount = object["net_amount"]
        @net_currency = object["net_currency"]
        @refunds = object["refunds"]
        @status = object["status"]
        @updated_at = object["updated_at"]

        super(object, response)
      end
    end
  end
end
