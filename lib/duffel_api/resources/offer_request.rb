# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class OfferRequest < BaseResource
      # @return [String, nil]
      attr_reader :cabin_class

      # @return [String]
      attr_reader :created_at

      # @return [String]
      attr_reader :id

      # @return [Boolean]
      attr_reader :live_mode

      # @return [Array<Hash>]
      attr_reader :offers

      # @return [Array<Hash>]
      attr_reader :passengers

      # @return [Array<Hash>]
      attr_reader :slices

      def initialize(object, response = nil)
        @object = object

        @cabin_class = object["cabin_class"]
        @created_at = object["created_at"]
        @id = object["id"]
        @live_mode = object["live_mode"]
        @offers = object["offers"]
        @passengers = object["passengers"]
        @slices = object["slices"]

        super(object, response)
      end
    end
  end
end
