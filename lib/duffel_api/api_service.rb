# frozen_string_literal: true

require "faraday"
require "uri"

module DuffelAPI
  # An internal class used within the library that is able to make requests to
  # the Duffel API and handle errors
  class APIService
    # Sets up an API service based on a base URL, access token and set of default
    # headers
    #
    # @param [String] base_url A test or live mode access token
    # @param [String] access_token The URL of the Duffel API
    # @param [Hash] default_headers The headers to include by default in HTTP requests
    # @return [APIService]
    def initialize(base_url, access_token, default_headers:)
      @base_url = base_url
      root_url, @path_prefix = unpack_url(base_url)

      @connection = Faraday.new(root_url) do |faraday|
        faraday.response :raise_duffel_errors

        faraday.adapter(:net_http)
      end

      @headers = default_headers.merge("Authorization" => "Bearer #{access_token}")
    end

    # Makes a request to the API, including any defauot headers
    #
    # @param [Symbol] method the HTTP method to make the request with
    # @param [String] path the path to make the request to
    # @param [Hash] options options to be passed with `Request#new`
    # @return [Request]
    def make_request(method, path, options = {})
      raise ArgumentError, "options must be a hash" unless options.is_a?(Hash)

      options[:headers] ||= {}
      options[:headers] = @headers.merge(options[:headers])
      Request.new(@connection, method, @path_prefix + path, **options).call
    end

    private

    def unpack_url(url)
      path = URI.parse(url).path
      [URI.join(url).to_s, path == "/" ? "" : path]
    end
  end
end
