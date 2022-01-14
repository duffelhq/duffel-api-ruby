# frozen_string_literal: true

require "faraday"

module DuffelAPI
  module Middlewares
    class RaiseDuffelErrors < Faraday::Middleware
      UNEXPECTED_ERROR_STATUSES = (501..599).freeze
      EXPECTED_ERROR_STATUSES = (400..500).freeze

      # Handles a completed (Faraday) request and raises an error, if appropriate
      #
      # @param [Faraday::Env] env
      def on_complete(env)
        if !json?(env) || UNEXPECTED_ERROR_STATUSES.include?(env.status)
          response = Response.new(env.response)
          raise DuffelAPI::Errors::Error.new(generate_error_data(env), response)
        end

        if EXPECTED_ERROR_STATUSES.include?(env.status)
          json_body ||= JSON.parse(env.body) unless env.body.empty?
          error = json_body["errors"].first
          error_type = error["type"]

          error_class = error_class_for_type(error_type)

          response = Response.new(env.response)

          raise error_class.new(error, response)
        end
      end

      private

      # Picks the correct error class to use for an error returned by the Duffel API
      # based on its type
      #
      # @param type [Atom] the type returned by the API
      # @return [Errors::Error]
      def error_class_for_type(type)
        {
          airline_error: DuffelAPI::Errors::AirlineError,
          api_error: DuffelAPI::Errors::APIError,
          authentication_error: DuffelAPI::Errors::AuthenticationError,
          invalid_request_error: DuffelAPI::Errors::InvalidRequestError,
          invalid_state_error: DuffelAPI::Errors::InvalidStateError,
          rate_limit_error: DuffelAPI::Errors::RateLimitError,
          validation_error: DuffelAPI::Errors::ValidationError,
        }.fetch(type.to_sym) || DuffelAPI::Errors::Error
      end

      # Generates error data - specifically a message - based on the `Faraday::Env` for
      # non-standard Duffel errors
      #
      # @param env [Faraday::Env]
      # @return [Hash]
      def generate_error_data(env)
        {
          "message" => "Something went wrong with this request\n" \
                       "Code: #{env.status}\n" \
                       "Headers: #{env.response_headers}\n" \
                       "Body: #{env.body}",
        }
      end

      # Works out if the response is a JSON response based on the `Faraday::Env`
      #
      # @param env [Faraday::Env]
      # @return [Boolean]
      def json?(env)
        content_type = env.response_headers["Content-Type"] ||
          env.response_headers["content-type"] || ""

        content_type.include?("application/json")
      end
    end
  end
end

Faraday::Response.register_middleware raise_duffel_errors: DuffelAPI::
    Middlewares::RaiseDuffelErrors
