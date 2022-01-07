# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class Airport < BaseResource
      attr_reader :city
      attr_reader :city_name
      attr_reader :iata_code
      attr_reader :iata_country_code
      attr_reader :icao_code
      attr_reader :id
      attr_reader :latitude
      attr_reader :longitude
      attr_reader :name
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
