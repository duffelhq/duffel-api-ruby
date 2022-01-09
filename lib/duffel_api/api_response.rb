# frozen_string_literal: true

module DuffelAPI
  # An HTTP response returned from the API
  class APIResponse
    extend Forwardable

    # Builds an `APIResponse` from a `Response`, the library's internal representation
    # of an HTTP response
    #
    # @param response [Response]
    # @return [APIResponse]
    def initialize(response)
      @response = response
    end

    # Returns the HTTP response headers
    #
    # @return [Hash]
    def headers
      @response.headers
    end

    # Returns the raw body of the HTTP response
    #
    # @return [String]
    def body
      @response.raw_body
    end

    # Returns the HTTP status code of the HTTP response
    #
    # @return [Integer]
    def status_code
      @response.status_code
    end

    # Returns the request ID from the Duffel API, included in the response headers.
    # This could be `nil` if the response didn't make it to the Duffel API itself and,
    # for example, only reached a load balancer.
    #
    # @return [String, nil]
    def request_id
      @response.request_id
    end
  end
end
