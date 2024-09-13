# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class Airline < BaseResource
      # @return [String, nil]
      attr_reader :iata_code

      # @return [String]
      attr_reader :id

      # @return [String]
      attr_reader :name

      # @return [String, nil]
      attr_reader :logo_lockup_url

      # @return [String, nil]
      attr_reader :logo_symbol_url

      def initialize(object, response = nil)
        @object = object

        @iata_code = object["iata_code"]
        @id = object["id"]
        @name = object["name"]
        @logo_lockup_url = object["logo_lockup_url"]
        @logo_symbol_url = object["logo_symbol_url"]

        super
      end
    end
  end
end
