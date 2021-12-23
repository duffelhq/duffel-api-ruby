# frozen_string_literal: true

module DuffelAPI
  module Services
    class WebhooksService < BaseService
      class PingResult
        attr_reader :api_response

        def initialize(api_response)
          @api_response = api_response
        end

        # If we return a `PingResult` rather than an error, then that means that the
        # action was successful.
        def succeeded
          true
        end
      end

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
      rescue DuffelAPI::Errors::Error => e
        # We expect this API call to *ALWAYS* lead to an error being raised since
        # it returns a non-JSON 204 response even if it's successful. We just catch
        # that and bubble it up in a nicer way.
        if e.api_response.status_code == 204
          PingResult.new(e.api_response)
        else
          raise e
        end
      end
    end
  end
end
