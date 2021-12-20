# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class Airline
      attr_reader :iata_code
      attr_reader :id
      attr_reader :name

      def initialize(object, response = nil)
        @object = object

        @iata_code = object["iata_code"]
        @id = object["id"]
        @name = object["name"]

        @response = response
      end

      def api_response
        APIResponse.new(@response)
      end
    end
  end
end
