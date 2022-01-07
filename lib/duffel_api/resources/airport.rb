# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class Airport < BaseResource
      # @return [Hash, nil]
      attr_reader :city

      # @return [String]
      attr_reader :city_name

      # @return [String]
      attr_reader :iata_code

      # @return [String]
      attr_reader :iata_country_code

      # @return [String]
      attr_reader :icao_code

      # @return [String]
      attr_reader :id

      # @return [Float]
      attr_reader :latitude

      # @return [Float]
      attr_reader :longitude

      # @return [String]
      attr_reader :name

      # @return [String]
      attr_reader :time_zone

      def initialize(object, response = nil)
        @object = object

        @city = object["city"]
        @city_name = object["city_name"]
        @iata_code = object["iata_code"]
        @iata_country_code = object["iata_country_code"]
        @icao_code = object["icao_code"]
        @id = object["id"]
        @latitude = object["latitude"]
        @longitude = object["longitude"]
        @name = object["name"]
        @time_zone = object["time_zone"]

        super(object, response)
      end
    end
  end
end
