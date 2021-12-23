# frozen_string_literal: true

module DuffelAPI
  # wraps a faraday response object with some accessors
  class APIResponse
    extend Forwardable

    def initialize(response)
      @response = response
    end

    def_delegator :@response, :headers
    def_delegator :@response, :raw_body, :body
    def_delegator :@response, :status_code
    def_delegator :@response, :request_id
  end
end
