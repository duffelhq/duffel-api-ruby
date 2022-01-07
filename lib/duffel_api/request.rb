# frozen_string_literal: true

require "json"

module DuffelAPI
  # A class that wraps an API request
  class Request
    # Initialize a request class, which makes calls to the API
    # @param connection
    # @param method [Symbol] the method to make the request with
    # @param path [String] the path to make the request to
    # @param options [hash] options for the request
    # @param headers [hash] headers to send with the request
    def initialize(connection, method, path, options)
      @connection = connection
      @method = method
      @path = path
      @headers = (options.delete(:headers) || {}).transform_keys(&:to_s)
      @given_options = options

      @request_body = request_body

      if @request_body.is_a?(Hash)
        @request_body = @request_body.to_json
        @headers["Content-Type"] ||= "application/json"
      end
    end

    # Dispatches the request and returns the result
    #
    # @return [Response] the response from the request
    def call
      Response.new(make_request)
    end

    private

    # Make the API request
    def make_request
      @connection.send(@method) do |request|
        request.url @path
        request.body = @request_body
        request.params = request_query
        request.headers.merge!(@headers)
      end
    end

    # Fetch the body to send with the request
    def request_body
      if @method == :get
        nil
      elsif %i[post put delete patch].include?(@method)
        @given_options.fetch(:params, {})
      else
        raise "Unknown request method #{@method}"
      end
    end

    # Get the query params to send with the request
    def request_query
      if @method == :get
        @given_options.fetch(:params, {})
      else
        @given_options.fetch(:query_params, {})
      end
    end
  end
end
