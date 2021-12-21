# frozen_string_literal: true

module DuffelAPI
  class Paginator
    def initialize(options = {})
      @service = options.fetch(:service)
      @options = options.fetch(:options)
    end

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
