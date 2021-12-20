# frozen_string_literal: true

module DuffelAPI
  module Services
    class AircraftService < BaseService
      def list(options = {})
        path = "/air/aircraft"

        response = make_request(:get, path, options)

        ListResponse.new(
          response: response,
          unenveloped_body: unenvelope_body(response.body),
          resource_class: Resources::Aircraft,
        )
      end

      def all(options = {})
        DuffelAPI::Paginator.new(
          service: self,
          options: options,
        ).enumerator
      end

      def get(id, options = {})
        path = substitute_url_pattern("/air/aircraft/:id", "id" => id)

        response = make_request(:get, path, options)

        return if response.body.nil?

        Resources::Aircraft.new(unenvelope_body(response.body), response)
      end
    end
  end
end
