# frozen_string_literal: true

require "simplecov"

if ENV["COVERAGE"]
  SimpleCov.start do
    enable_coverage :branch
  end
end

require "webmock/rspec"
require "rspec/its"
require_relative "../lib/duffel_api"
require_relative "helpers/fixture_helper"

RSpec.configure do |config|
  config.include DuffelAPI::FixtureHelper

  config.expect_with :rspec do |c|
    c.syntax = :expect
    c.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |c|
    c.verify_partial_doubles = true
  end
end
