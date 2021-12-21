# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class Payment < BaseResource
      attr_reader :amount
      attr_reader :created_at
      attr_reader :currency
      attr_reader :id
      attr_reader :type

      def initialize(object, response = nil)
        @object = object

        @amount = object["amount"]
        @created_at = object["created_at"]
        @currency = object["currency"]
        @id = object["id"]
        @type = object["type"]

        super(object, response)
      end
    end
  end
end
