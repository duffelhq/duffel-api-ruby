# frozen_string_literal: true

module DuffelAPI
  module Services
    class AirlinesService < BaseService
      def list(options = {})
        path = "/air/airlines"

        response = make_request(:get, path, options)

        ListResponse.new(
          response: response,
          unenveloped_body: unenvelope_body(response.parsed_body),
          resource_class: Resources::Airline,
        )
      end

      def all(options = {})
        DuffelAPI::Paginator.new(
          service: self,
          options: options,
        ).enumerator
      end

      def get(id, options = {})
        path = substitute_url_pattern("/air/airlines/:id", "id" => id)

        response = make_request(:get, path, options)

        return if response.raw_body.nil?

        Resources::Airline.new(unenvelope_body(response.parsed_body), response)
      end
    end
  end
end
