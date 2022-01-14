# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class Order < BaseResource
      attr_reader :base_amount
      attr_reader :base_currency
      attr_reader :booking_reference
      attr_reader :cancelled_at
      attr_reader :conditions
      attr_reader :created_at
      attr_reader :documents
      attr_reader :id
      attr_reader :live_mode
      attr_reader :metadata
      attr_reader :owner
      attr_reader :passengers
      attr_reader :payment_status
      attr_reader :services
      attr_reader :slices
      attr_reader :synced_at
      attr_reader :tax_amount
      attr_reader :tax_currency
      attr_reader :total_amount
      attr_reader :total_currency

      def initialize(object, response = nil)
        @object = object

        @base_amount = object["base_amount"]
        @base_currency = object["base_currency"]
        @booking_reference = object["booking_reference"]
        @cancelled_at = object["cancelled_at"]
        @conditions = object["conditions"]
        @created_at = object["created_at"]
        @documents = object["documents"]
        @id = object["id"]
        @live_mode = object["live_mode"]
        @metadata = object["metadata"]
        @owner = object["owner"]
        @passengers = object["passengers"]
        @payment_status = object["payment_status"]
        @services = object["services"]
        @slices = object["slices"]
        @synced_at = object["synced_at"]
        @tax_amount = object["tax_amount"]
        @tax_currency = object["tax_currency"]
        @total_amount = object["total_amount"]
        @total_currency = object["total_currency"]

        super(object, response)
      end
    end
  end
end
