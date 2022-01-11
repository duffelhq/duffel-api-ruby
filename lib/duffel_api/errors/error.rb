# frozen_string_literal: true

module DuffelAPI
  module Errors
    class Error < StandardError
      attr_reader :error

      # Builds an error, which provides access to the raw response. In general,
      # subclasses of this error (e.g. `APIError`) will be raised, apart from
      # for unrecognised errors returned by the Duffel API or errors that don't
      # look like standardised Duffel API errors.
      #
      # @param error [Hash] the parsed error data from the API
      # @param response [APIResponse, nil]
      # @return [Error]
      def initialize(error, response = nil)
        raise ArgumentError, "Duffel errors expect a hash" unless error.is_a?(Hash)

        @error = error
        @response = response

        super(error)
      end

      # Returns a URL where documentation about the error can be found. This can be
      # `nil` for errors that don't look like standardised Duffel errors (e.g. errors
      # returned by the load balancer rather than the API itself).
      #
      # @return [String, nil]
      def documentation_url
        @error["documentation_url"]
      end

      # Returns the title associated with the error. This can be `nil` for errors that
      # don't look like standardised Duffel errors (e.g. errors returned by the load
      # balancer rather than the API itself).
      #
      # @return [String, nil]
      def title
        @error["title"]
      end

      # Return the message associated with the error
      #
      # @return [String]
      def message
        @error["message"]
      end

      # Returns a string representation of the error, taken from its `#message`
      #
      # @return [String]
      def to_s
        @error["message"]
      end

      # Returns the type of the error. See the Duffel API reference for possible values.
      # This can be `nil` for errors that don't look like standardised Duffel errors
      # (e.g. errors returned by the load balancer rather than the API itself).
      #
      # @return [String, nil]
      def type
        @error["type"]
      end

      # Returns the code of the error. See the Duffel API reference for possible values.
      # This can be `nil` for errors that don't look like standardised Duffel errors
      # (e.g. errors returned by the load balancer rather than the API itself).
      #
      # @return [String, nil]
      def code
        @error["code"]
      end

      # Returns the request ID of the request that generated the error.
      #
      # @return [String]
      def request_id
        api_response.request_id
      end

      # Return s the source of the error.
      #
      # @return [Hash, nil]
      def source
        @error["source"]
      end

      # Returns the raw API response where this error originated from
      #
      # @return [APIResponse]
      def api_response
        APIResponse.new(@response)
      end
    end
  end
end
