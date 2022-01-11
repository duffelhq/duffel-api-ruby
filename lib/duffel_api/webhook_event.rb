# frozen_string_literal: true

require "base16"
require "openssl"

module DuffelAPI
  module WebhookEvent
    # An exception raised internally within the library - but not exposed - if the
    # webhook signature provided does not match the format of a valid signature
    class InvalidRequestSignatureError < StandardError; end

    SIGNATURE_REGEXP = /\At=(.+),v1=(.+)\z/.freeze

    SHA_256 = OpenSSL::Digest.new("sha256")

    class << self
      # Checks if a webhook event you received was a genuine webhook event from Duffel by
      # checking that it was signed with your shared secret.
      #
      # Assuming that you've kept that secret secure and only shared it with Duffel,
      # this can give you confidence that a webhook event was genuinely sent by Duffel.
      #
      # @param request_body [String] The raw body of the received request
      # @param request_signature [String] The signature provided with the received
      #   request, found in the `X-Duffel-Signature` request header
      # @param webhook_secret [String] The secret of the webhook, registered with Duffel
      # @return [Boolean] whether the webhook signature matches
      def genuine?(request_body:, request_signature:, webhook_secret:)
        parsed_signature = parse_signature!(request_signature)

        calculated_hmac = calculate_hmac(
          payload: request_body,
          secret: webhook_secret,
          timestamp: parsed_signature[:timestamp],
        )

        secure_compare(calculated_hmac, parsed_signature[:v1])
      rescue InvalidRequestSignatureError
        # If the signature doesn't even look like a valid one, then the webhook
        # event can't be genuine
        false
      end

      private

      # Calculates the signature for a request body in the same way that the Duffel API
      # does it
      #
      # @param secret [String]
      # @param payload [String]
      # @param timestamp [String]
      # @return [String]
      def calculate_hmac(secret:, payload:, timestamp:)
        signed_payload = %(#{timestamp}.#{payload})
        Base16.encode16(OpenSSL::HMAC.digest(SHA_256, secret,
                                             signed_payload)).strip.downcase
      end

      # Parses a webhook signature and extracts the `v1` and `timestamp` values, if
      # available.
      #
      # @param signature [String] A webhook event signature received in a request
      # @return [Hash]
      # @raise InvalidRequestSignatureError when the signature isn't valid
      def parse_signature!(signature)
        matches = signature.match(SIGNATURE_REGEXP)

        if matches
          {
            v1: matches[2],
            timestamp: matches[1],
          }
        else
          raise InvalidRequestSignatureError
        end
      end

      # Taken from `Rack::Utils`
      # (<https://github.com/rack/rack/blob/03b4b9708f375db46ee214b219f709d08ed6eeb0/lib/rack/utils.rb#L371-L393>).
      #
      # Licensed under the MIT License
      # (<https://github.com/rack/rack/blob/master/MIT-LICENSE>).
      if defined?(OpenSSL.fixed_length_secure_compare)
        # Checks if two strings are equal, performing a constant time string comparison
        # resistant to timing attacks.
        #
        # @param a [String]
        # @param b [String]
        # @return [Boolean] whether the two strings are equal
        # rubocop:disable Naming/MethodParameterName
        def secure_compare(a, b)
          # rubocop:enable Naming/MethodParameterName
          return false unless a.bytesize == b.bytesize

          OpenSSL.fixed_length_secure_compare(a, b)
        end
      else
        # Checks if two strings are equal, performing a constant time string comparison
        # resistant to timing attacks.
        #
        # @param [String] a
        # @param [String] b
        # @return [Boolean] whether the two strings are equal
        # rubocop:disable Naming/MethodParameterName
        def secure_compare(a, b)
          # rubocop:enable Naming/MethodParameterName
          return false unless a.bytesize == b.bytesize

          l = a.unpack("C*")

          r = 0
          i = -1
          b.each_byte { |v| r |= v ^ l[i += 1] }
          r.zero?
        end
      end
    end
  end
end
