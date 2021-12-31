# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class Webhook < BaseResource
      attr_reader :active
      attr_reader :created_at
      attr_reader :events
      attr_reader :id
      attr_reader :live_mode
      attr_reader :secret
      attr_reader :updated_at
      attr_reader :url

      def initialize(object, response = nil)
        @object = object

        @active = object["active"]
        @created_at = object["created_at"]
        @events = object["events"]
        @id = object["id"]
        @live_mode = object["live_mode"]
        @secret = object["secret"]
        @updated_at = object["updated_at"]
        @url = object["url"]

        super(object, response)
      end
    end
  end
end
