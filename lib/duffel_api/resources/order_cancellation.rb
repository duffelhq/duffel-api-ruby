# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class OrderCancellation < BaseResource
      attr_reader :confirmed_at
      attr_reader :created_at
      attr_reader :expires_at
      attr_reader :id
      attr_reader :live_mode
      attr_reader :order_id
      attr_reader :refund_amount
      attr_reader :refund_currency
      attr_reader :refund_to

      def initialize(object, response = nil)
        @object = object

        @confirmed_at = object["confirmed_at"]
        @created_at = object["created_at"]
        @expires_at = object["expires_at"]
        @id = object["id"]
        @live_mode = object["live_mode"]
        @order_id = object["order_id"]
        @refund_amount = object["refund_amount"]
        @refund_currency = object["refund_currency"]
        @refund_to = object["refund_to"]

        super(object, response)
      end
    end
  end
end
