# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class Offer < BaseResource
      attr_reader :allowed_passenger_identity_document_types
      attr_reader :available_services
      attr_reader :base_amount
      attr_reader :base_currency
      attr_reader :conditions
      attr_reader :created_at
      attr_reader :expires_at
      attr_reader :id
      attr_reader :live_mode
      attr_reader :owner
      attr_reader :passenger_identity_documents_required
      attr_reader :passengers
      attr_reader :payment_requirements
      attr_reader :slices
      attr_reader :tax_amount
      attr_reader :tax_currency
      attr_reader :total_amount
      attr_reader :total_currency
      attr_reader :total_emissions_kg
      attr_reader :updated_at

      def initialize(object, response = nil)
        @object = object

        @allowed_passenger_identity_document_types =
          object["allowed_passenger_identity_document_types"]
        @available_services = object["available_services"]
        @base_amount = object["base_amount"]
        @base_currency = object["base_currency"]
        @conditions = object["conditions"]
        @created_at = object["created_at"]
        @expires_at = object["expires_at"]
        @id = object["id"]
        @live_mode = object["live_mode"]
        @owner = object["owner"]
        @passenger_identity_documents_required =
          object["passenger_identity_documents_required"]
        @passengers = object["passengers"]
        @payment_requirements = object["payment_requirements"]
        @slices = object["slices"]
        @tax_amount = object["tax_amount"]
        @tax_currency = object["tax_currency"]
        @total_amount = object["total_amount"]
        @total_currency = object["total_currency"]
        @total_emissions_kg = object["total_emissions_kg"]
        @updated_at = object["updated_at"]

        super(object, response)
      end
    end
  end
end
