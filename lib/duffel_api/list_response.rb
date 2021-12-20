# frozen_string_literal: true

module DuffelAPI
  class ListResponse
    attr_reader :records

    def initialize(options = {})
      @response = options.fetch(:response)
      @resource_class = options.fetch(:resource_class)
      @unenveloped_body = options.fetch(:unenveloped_body)

      @records = @unenveloped_body.map { |item| @resource_class.new(item) }
    end

    def api_response
      @api_response ||= APIResponse.new(@response)
    end

    def before
      @response.body["meta"]["before"]
    end

    def after
      @response.body["meta"]["after"]
    end
  end
end
