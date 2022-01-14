# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class OrderChangeOffer < BaseResource
      attr_reader :change_total_amount
      attr_reader :change_total_currency
      attr_reader :created_at
      attr_reader :expires_at
      attr_reader :id
      attr_reader :live_mode
      attr_reader :new_total_amount
      attr_reader :new_total_currency
      attr_reader :order_change_id
      attr_reader :penalty_total_amount
      attr_reader :penalty_total_currency
      attr_reader :refund_to
      attr_reader :slices
      attr_reader :updated_at

      def initialize(object, response = nil)
        @object = object

        @change_total_amount = object["change_total_amount"]
        @change_total_currency = object["change_total_currency"]
        @created_at = object["created_at"]
        @expires_at = object["expires_at"]
        @id = object["id"]
        @live_mode = object["live_mode"]
        @new_total_amount = object["new_total_amount"]
        @new_total_currency = object["new_total_currency"]
        @order_change_id = object["order_change_id"]
        @penalty_total_amount = object["penalty_total_amount"]
        @penalty_total_currency = object["penalty_total_currency"]
        @refund_to = object["refund_to"]
        @slices = object["slices"]
        @updated_at = object["updated_at"]

        super(object, response)
      end
    end
  end
end
