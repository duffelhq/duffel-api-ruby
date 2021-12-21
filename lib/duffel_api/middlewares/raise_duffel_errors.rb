# frozen_string_literal: true

require "faraday"

module DuffelAPI
  module Middlewares
    class RaiseDuffelErrors < Faraday::Response::Middleware
      API_ERROR_STATUSES = (501..599).freeze
      CLIENT_ERROR_STATUSES = (400..500).freeze

      # rubocop:disable Metrics/AbcSize
      def on_complete(env)
        if !json?(env) || API_ERROR_STATUSES.include?(env.status)
          response = Response.new(env.response)
          raise DuffelAPI::Errors::Error.new(generate_error_data(env), response)
        end

        if CLIENT_ERROR_STATUSES.include?(env.status)
          json_body ||= JSON.parse(env.body) unless env.body.empty?
          error = json_body["errors"].first
          error_type = error["type"]

          error_class = error_class_for_type(error_type)

          response = Response.new(env.response)

          raise error_class.new(error, response)
        end
      end
      # rubocop:enable Metrics/AbcSize

      private

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

      def generate_error_data(env)
        {
          "message" => "Something went wrong with this request\n" \
                       "Code: #{env.status}\n" \
                       "Headers: #{env.response_headers}\n" \
                       "Body: #{env.body}",
          "code" => env.status,
        }
      end

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
