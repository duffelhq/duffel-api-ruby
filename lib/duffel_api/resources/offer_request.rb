# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class OfferRequest
      attr_reader :cabin_class
      attr_reader :created_at
      attr_reader :id
      attr_reader :live_mode
      attr_reader :offers
      attr_reader :passengers
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

        @response = response
      end

      def api_response
        APIResponse.new(@response)
      end
    end
  end
end
