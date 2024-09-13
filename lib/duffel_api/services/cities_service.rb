# frozen_string_literal: true

module DuffelAPI
  module Services
    class CitiesService < BaseService
      # Lists cities, returning a single page of results
      #
      # @option [Hash] :params Parameters to include in the HTTP querystring, including
      #   any filters
      # @return [ListResponse]
      # @raise [Errors::Error] when the Duffel API returns an error
      def list(options = {})
        path = "/air/cities"

        response = make_request(:get, path, options)

        ListResponse.new(
          response: response,
          unenveloped_body: unenvelope_body(response.parsed_body),
          resource_class: Resources::City,
        )
      end

      # Returns an `Enumerator` which can automatically cycle through multiple
      # pages of `Resources::City`s.
      #
      # By default, this will use pages of 200 results under the hood, but this
      # can be customised by specifying the `:limit` option in the `:params`.
      #
      # @param options [Hash] options passed to `#list`, for example `:params` to
      #   send an HTTP querystring with filters
      # @return [Enumerator]
      # @raise [Errors::Error] when the Duffel API returns an error
      def all(options = {})
        options[:params] = DEFAULT_ALL_PARAMS.merge(options[:params] || {})

        DuffelAPI::Paginator.new(
          service: self,
          options: options,
        ).enumerator
      end

      # Retrieves a single city by ID
      #
      # @param id [String]
      # @return [Resources::City]
      # @raise [Errors::Error] when the Duffel API returns an error
      def get(id, options = {})
        path = substitute_url_pattern("/air/cities/:id", "id" => id)

        response = make_request(:get, path, options)

        return if response.raw_body.nil?

        Resources::City.new(unenvelope_body(response.parsed_body), response)
      end
    end
  end
end
