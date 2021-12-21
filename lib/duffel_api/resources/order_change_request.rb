# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class OrderChangeRequest < BaseResource
      attr_reader :id
      attr_reader :live_mode
      attr_reader :order_change_offers
      # TODO: The docs say that we'll return an `order_id`, but we don't. We should fix
      # the API and uncomment this, or fix the docs and remove this.
      # attr_reader :order_id
      attr_reader :slices

      def initialize(object, response = nil)
        @object = object

        @id = object["id"]
        @live_mode = object["live_mode"]
        @order_change_offers = object["order_change_offers"]
        # @order_id = object["order_id"]
        @slices = object["slices"]

        super(object, response)
      end
    end
  end
end
