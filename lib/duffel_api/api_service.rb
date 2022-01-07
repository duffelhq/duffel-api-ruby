# frozen_string_literal: true

require "faraday"
require "uri"

module DuffelAPI
  class APIService
    def initialize(base_url, access_token, default_headers:)
      @base_url = base_url
      root_url, @path_prefix = unpack_url(base_url)

      @connection = Faraday.new(root_url) do |faraday|
        faraday.response :raise_duffel_errors

        faraday.adapter(:net_http)
      end

      @headers = default_headers.merge("Authorization" => "Bearer #{access_token}")
    end

    #
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
