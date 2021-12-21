# frozen_string_literal: true

module DuffelAPI
  module Services
    class AirportsService < BaseService
      def list(options = {})
        path = "/air/airports"

        response = make_request(:get, path, options)

        ListResponse.new(
          response: response,
          unenveloped_body: unenvelope_body(response.parsed_body),
          resource_class: Resources::Airport,
        )
      end

      def all(options = {})
        DuffelAPI::Paginator.new(
          service: self,
          options: options,
        ).enumerator
      end

      def get(id, options = {})
        path = substitute_url_pattern("/air/airports/:id", "id" => id)

        response = make_request(:get, path, options)

        return if response.raw_body.nil?

        Resources::Airport.new(unenvelope_body(response.parsed_body), response)
      end
    end
  end
end
