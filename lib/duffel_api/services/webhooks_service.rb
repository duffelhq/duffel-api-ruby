# frozen_string_literal: true

module DuffelAPI
  module Services
    class WebhooksService < BaseService
      def create(options = {})
        path = "/air/webhooks"

        params = options.delete(:params) || {}
        options[:params] = {}
        options[:params]["data"] = params

        begin
          response = make_request(:post, path, options)

          # Response doesn't raise any errors until #body is called
          response.tap(&:raw_body)
        end

        return if response.raw_body.nil?

        Resources::Webhook.new(unenvelope_body(response.parsed_body), response)
      end

      def update(id, options = {})
        path = substitute_url_pattern("/air/webhooks/:id", "id" => id)

        params = options.delete(:params) || {}
        options[:params] = {}
        options[:params]["data"] = params

        begin
          response = make_request(:patch, path, options)

          # Response doesn't raise any errors until #body is called
          response.tap(&:raw_body)
        end

        return if response.raw_body.nil?

        Resources::Webhook.new(unenvelope_body(response.parsed_body), response)
      end

      # rubocop:disable Metrics/AbcSize
      def ping(id, options = {})
        path = substitute_url_pattern("/air/webhooks/:id/actions/ping", "id" => id)

        params = options.delete(:params) || {}
        options[:params] = {}
        options[:params]["data"] = params

        begin
          response = make_request(:post, path, options)

          # Response doesn't raise any errors until #body is called
          response.tap(&:raw_body)
        end

        return if response.raw_body.nil?

        Resources::Webhook.new(unenvelope_body(response.parsed_body), response)
      rescue DuffelAPI::Errors::Error => e
        if e.api_response.status_code == 204
          true
        else
          raise e
        end
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
