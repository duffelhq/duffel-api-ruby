# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class BaseResource
      def initialize(_object, response)
        @response = response
      end

      # Returns the raw API response where this resource originated from
      #
      # @return [APIResponse]
      def api_response
        APIResponse.new(@response)
      end
    end
  end
end
