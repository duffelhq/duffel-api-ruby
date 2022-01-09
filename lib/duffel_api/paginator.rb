# frozen_string_literal: true

module DuffelAPI
  # An internal class used within the library to paginated automatically thruogh results
  # from list actions that can be spread over multiple pages
  class Paginator
    # @param service [Services::BaseService] a service which implements `#list`
    # @param options [Hash] the options originally passed to `#all`
    def initialize(service:, options:)
      @service = service
      @options = options
    end

    # Returns an enumerator that is able to automatically cycle through paginated data
    # returned by the API
    #
    # @return [Enumerator]
    def enumerator
      response = @service.list(@options)

      Enumerator.new do |yielder|
        loop do
          response.records.each { |item| yielder << item }

          after_cursor = response.after
          break if after_cursor.nil?

          @options[:params] ||= {}
          @options[:params] = @options[:params].merge(after: after_cursor)
          response = @service.list(@options)
        end
      end.lazy
    end
  end
end
