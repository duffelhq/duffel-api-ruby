# frozen_string_literal: true

module DuffelAPI
  # A page of results returned by a "list" action in the API, provides access to the
  # records on the page, and metadata about the page itself.
  class ListResponse
    # Returns the records contained within the page
    #
    # @return [Array<Resources::BaseResource>] an array of records - for example, for the
    #   list action for offers, this would be a list of `Resources::Offer`s
    attr_reader :records

    def initialize(options = {})
      @response = options.fetch(:response)
      @resource_class = options.fetch(:resource_class)
      @unenveloped_body = options.fetch(:unenveloped_body)

      @records = @unenveloped_body.map { |item| @resource_class.new(item, @response) }
    end

    # Returns the raw API response received for this listing request
    #
    # @return [APIResponse]
    def api_response
      @api_response ||= APIResponse.new(@response)
    end

    # Returns the cursor representing the previous page of paginated results, if there is
    # a previous page
    #
    # @return [String, nil]
    def before
      @response.parsed_body["meta"]["before"]
    end

    # Returns the cursor representing the next page of paginated results, if there is
    # a next page
    #
    # @return [String, nil]
    def after
      @response.parsed_body["meta"]["after"]
    end
  end
end
