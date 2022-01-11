# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class Aircraft < BaseResource
      # @return [String]
      attr_reader :iata_code

      # @return [String]
      attr_reader :id

      # @return [String]
      attr_reader :name

      def initialize(object, response = nil)
        @object = object

        @iata_code = object["iata_code"]
        @id = object["id"]
        @name = object["name"]

        super(object, response)
      end
    end
  end
end
