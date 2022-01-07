# frozen_string_literal: true

require "cgi"

module DuffelAPI
  module Services
    class BaseService
      def initialize(api_service)
        @api_service = api_service
      end

      private

      def make_request(method, path, options = {})
        @api_service.make_request(method, path, options)
      end

      def substitute_url_pattern(url, param_map)
        param_map.reduce(url) do |new_url, (param, value)|
          new_url.gsub(":#{param}", CGI.escape(value))
        end
      end

      def unenvelope_body(parsed_body)
        parsed_body["data"]
      end
    end
  end
end
