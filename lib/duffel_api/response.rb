# frozen_string_literal: true

module DuffelAPI
  # An internal class used within the library to represent a response from the Duffel
  # API
  class Response
    extend Forwardable

    def_delegator :@response, :headers
    def_delegator :@response, :status, :status_code

    # Wraps a `Faraday::Response` in the library's own internal response class
    #
    # @param [Faraday::Response] response
    # @return [Response]
    def initialize(response)
      @response = response
    end

    # Returns the raw body of the HTTP response
    #
    # @return [String]
    def raw_body
      @response.body
    end

    # Return the parsed JSON body of the API response, if a body was returned
    #
    # @return [Hash, nil]
    def parsed_body
      JSON.parse(raw_body) unless raw_body.empty?
    end

    # Returns the `meta` data returned from the Duffel API, if present. If not present,
    # returns an empty hash (`{}`).
    #
    # @return [Hash]
    def meta
      return {} if parsed_body.nil?

      parsed_body.fetch("meta", {})
    rescue JSON::ParserError
      {}
    end

    # Returns the request ID from the Duffel API, included in the response headers.
    # This could be `nil` if the response didn't make it to the Duffel API itself and,
    # for example, only reached a load balancer.
    #
    # @return [String, nil]
    def request_id
      normalised_headers["x-request-id"]
    end

    private

    # Returns the HTTP response headers, with all of their keys in lower case
    #
    # @return [Hash]
    def normalised_headers
      headers.transform_keys(&:downcase)
    end
  end
end
