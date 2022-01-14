# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class Refund < BaseResource
      attr_reader :amount
      attr_reader :arrival
      attr_reader :created_at
      attr_reader :currency
      attr_reader :destination
      attr_reader :id
      attr_reader :live_mode
      attr_reader :net_amount
      attr_reader :net_currency
      attr_reader :payment_intent_id
      attr_reader :status
      attr_reader :updated_at

      def initialize(object, response = nil)
        @object = object

        @amount = object["amount"]
        @arrival = object["arrival"]
        @created_at = object["created_at"]
        @currency = object["currency"]
        @destination = object["destination"]
        @id = object["id"]
        @live_mode = object["live_mode"]
        @net_amount = object["net_amount"]
        @net_currency = object["net_currency"]
        @payment_intent_id = object["payment_intent_id"]
        @status = object["status"]
        @updated_at = object["updated_at"]

        super(object, response)
      end
    end
  end
end
