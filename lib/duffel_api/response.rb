# frozen_string_literal: true

module DuffelAPI
  class Response
    extend Forwardable

    def_delegator :@response, :headers
    def_delegator :@response, :status, :status_code

    def initialize(response)
      @response = response
    end

    def raw_body
      @response.body
    end

    # Return the body of parsed JSON body of the API response
    def parsed_body
      JSON.parse(raw_body) unless raw_body.empty?
    end

    # Returns the meta hash of the response
    def meta
      return {} if parsed_body.nil?

      parsed_body.fetch("meta", {})
    rescue JSON::ParserError
      {}
    end

    # Returns the request ID from the response headers
    def request_id
      normalised_headers["x-request-id"]
    end

    private

    def normalised_headers
      headers.transform_keys(&:downcase)
    end

    def json?; end
  end
end
