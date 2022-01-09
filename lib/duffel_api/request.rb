# frozen_string_literal: true

require "json"

module DuffelAPI
  # An internal class used within the library that represents a request to be made to
  # the Duffel API, and which is able to dispatch that request
  class Request
    # Initialize a request class, which makes calls to the API
    #
    # @param connection [Faraday] a Faraday connection
    # @param method [Symbol] the HTTP method to make the request with
    # @param path [String] the path to make the request to
    # @param headers [Hash] the HTTP request headers to send with the request
    # @param params [Hash] Any paramters to include in the HTTP body
    # @param query_params [Hash] Any parameters to include in the HTTP querystring
    def initialize(connection, method, path, headers: {}, params: {}, query_params: {})
      @connection = connection
      @method = method
      @path = path
      @headers = headers.transform_keys(&:to_s)
      @option = params
      @query_params = query_params

      @request_body = request_body

      if @request_body.is_a?(Hash)
        @request_body = @request_body.to_json
        @headers["Content-Type"] ||= "application/json"
      end
    end

    # Dispatches the request and returns the response
    #
    # @return [Response] the response from the request
    def call
      Response.new(make_request)
    end

    private

    # Actually makes the request to the API
    #
    # @return [Faraday::Response]
    def make_request
      @connection.send(@method) do |request|
        request.url @path
        request.body = @request_body
        request.params = request_query
        request.headers.merge!(@headers)
      end
    end

    # Fetches the appropriate parameters to put into the request body, based on the HTTP
    # method
    #
    # @return [Hash] the parameters to put into the request body, not yet JSON-encoded
    def request_body
      if @method == :get
        nil
      elsif %i[post put delete patch].include?(@method)
        @option
      else
        raise "Unknown request method #{@method}"
      end
    end

    # Fetches the appropriate parameters to put into the request querystring, based on
    # the HTTP method
    #
    # @return [Hash] the parameters to put into the request querystring
    def request_query
      if @method == :get
        @option
      else
        @query_params
      end
    end
  end
end
