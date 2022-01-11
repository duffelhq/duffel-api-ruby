# frozen_string_literal: true

module DuffelAPI
  module Services
    class WebhooksService < BaseService
      class PingResult
        # Returns the raw API response this resource originated from
        #
        # @return [APIResponse]
        attr_reader :api_response

        def initialize(api_response)
          @api_response = api_response
        end

        # Returns whether the ping was successful. This is always true, because if the
        # ping fails, we raise an error.
        #
        # @return [Boolean]
        def succeeded
          true
        end
      end

      # Creates an webhook
      #
      # @option [required, Hash] :params the payload for creating the webhook
      # @return [Resources::Webhook]
      # @raise [Errors::Error] when the Duffel API returns an error
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

      # Updates a webhook by ID
      #
      # @param id [String]
      # @option [required, Hash] :params the payload for updating the webhook
      # @return [Resources::Webhook]
      # @raise [Errors::Error] when the Duffel API returns an error
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

      # Pings a webhook by ID
      #
      # @param id [String]
      # @return [PingResult]
      # @raise [Errors::Error] when the Duffel API returns an error
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
