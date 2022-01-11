# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class OfferPassenger < BaseResource
      # @return [String, nil]
      attr_reader :type

      # @return [Array<Hash>]
      attr_reader :loyalty_programme_accounts

      # @return [String]
      attr_reader :id

      # @return [String, nil]
      attr_reader :given_name

      # @return [String, nil]
      attr_reader :family_name

      # @return [String, nil]
      attr_reader :age

      def initialize(object, response = nil)
        @object = object

        @type = object["type"]
        @loyalty_programme_accounts = object["loyalty_programme_accounts"]
        @id = object["id"]
        @given_name = object["given_name"]
        @family_name = object["family_name"]
        @age = object["age"]

        super(object, response)
      end
    end
  end
end
