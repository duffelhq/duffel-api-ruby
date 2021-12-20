# frozen_string_literal: true

module DuffelAPI
  module Errors
    class Error < StandardError
      attr_reader :error

      def initialize(error, response = nil)
        raise ArgumentError, "Duffel errors expect a hash" unless error.is_a?(Hash)

        @error = error
        @response = response

        super(error)
      end

      def documentation_url
        @error["documentation_url"]
      end

      def title
        @error["title"]
      end

      def message
        @error["message"]
      end

      def to_s
        @error["message"]
      end

      def type
        @error["type"]
      end

      def code
        @error["code"]
      end

      def request_id
        @error["request_id"]
      end

      def source
        @error["source"]
      end

      def api_response
        APIResponse.new(@response)
      end
    end
  end
end
