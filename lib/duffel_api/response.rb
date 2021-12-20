# frozen_string_literal: true

module DuffelAPI
  class Response
    extend Forwardable

    def_delegator :@response, :headers
    def_delegator :@response, :status, :status_code

    def initialize(response)
      @response = response
    end

    # Return the body of parsed JSON body of the API response
    def body
      JSON.parse(@response.body) unless @response.body.empty?
    end

    # Returns the meta hash of the response
    def meta
      body.fetch("meta", {})
    end

    # Returns the request ID from the response headers
    def request_id
      normalised_headers["x-request-id"]
    end

    private

    def normalised_headers
      headers.transform_keys(&:downcase)
    end
  end
end
