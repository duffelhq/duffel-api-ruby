# frozen_string_literal: true

require "json"

module DuffelAPI
  module FixtureHelper
    # Loads a fixture from `spec/fixtures` by its path
    def load_fixture(path)
      File.read(fixture_path + "/" + path)
    end

    # Rewrites a list response returned by the Duffel API, rewriting the `meta.after`
    # data so the page appears like a "last page", with no more data to fetch.
    def convert_list_response_to_last_page(raw_json)
      parsed_body = JSON.parse(raw_json)

      parsed_body["meta"]["after"] = nil

      parsed_body.to_json
    end

    private

    def fixture_path
      File.expand_path("../fixtures", __dir__)
    end
  end
end
