# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class OrderChangeRequest < BaseResource
      attr_reader :created_at
      attr_reader :id
      attr_reader :live_mode
      attr_reader :order_change_offers
      attr_reader :order_id
      attr_reader :slices
      attr_reader :updated_at

      def initialize(object, response = nil)
        @object = object

        @created_at = object["created_at"]
        @id = object["id"]
        @live_mode = object["live_mode"]
        @order_change_offers = object["order_change_offers"]
        @order_id = object["order_id"]
        @slices = object["slices"]
        @updated_at = object["updated_at"]

        super(object, response)
      end
    end
  end
end
