# frozen_string_literal: true

require "cgi"

module DuffelAPI
  module Services
    class BaseService
      extend Forwardable

      # Sets up a resource-specific service based on an API service
      #
      # @param api_service [APIService]
      # @return [BaseService]
      def initialize(api_service)
        @api_service = api_service
      end

      private

      def_delegator :@api_service, :make_request

      # Fills in variables in a patterned URL (e.g. `/widgets/:id`)
      #
      # @param url [String]
      # @param param_map [Hash]
      # @return [String]
      def substitute_url_pattern(url, param_map)
        param_map.reduce(url) do |new_url, (param, value)|
          new_url.gsub(":#{param}", CGI.escape(value))
        end
      end

      # Extracts the data inside the `data` envelope from an API response
      #
      # @param parsed_body [Hash]
      # @return [Hash]
      def unenvelope_body(parsed_body)
        parsed_body["data"]
      end
    end
  end
end
