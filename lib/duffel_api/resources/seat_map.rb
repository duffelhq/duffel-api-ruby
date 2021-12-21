# encoding: utf-8
# frozen_string_literal: true

module DuffelAPI
  module Resources
    class SeatMap < BaseResource
      attr_reader :cabins
      attr_reader :id
      attr_reader :segment_id
      attr_reader :slice_id

      def initialize(object, response = nil)
        @object = object

        @cabins = object["cabins"]
        @id = object["id"]
        @segment_id = object["segment_id"]
        @slice_id = object["slice_id"]

        super(object, response)
      end
    end
  end
end
