# frozen_string_literal: true

module DuffelAPI
  module Services
    class OffersService < BaseService
      def list(options = {})
        path = "/air/offers"

        response = make_request(:get, path, options)

        ListResponse.new(
          response: response,
          unenveloped_body: unenvelope_body(response.body),
          resource_class: Resources::Offer,
        )
      end

      def all(options = {})
        Paginator.new(
          service: self,
          options: options,
        ).enumerator
      end

      def get(id, options = {})
        path = substitute_url_pattern("/air/offers/:id", "id" => id)

        response = make_request(:get, path, options)

        return if response.body.nil?

        Resources::Offer.new(unenvelope_body(response.body), response)
      end
    end
  end
end
