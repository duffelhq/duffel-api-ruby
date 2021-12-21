# frozen_string_literal: true

require "spec_helper"
require "json"

describe DuffelAPI::APIResponse do
  describe "wrapping a Faraday response" do
    subject(:api_response) do
      described_class.new(
        DuffelAPI::Response.new(test.get("/testing")),
      )
    end

    let(:content_type) { "application/json" }

    let(:stubbed) do
      Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get("/testing") do |_env|
          [200, { "Content-Type" => content_type }, { test: true }.to_json]
        end
      end
    end
    let(:test) { Faraday.new { |builder| builder.adapter :test, stubbed } }

    its(:status_code) { is_expected.to eq(200) }
    its(:headers) { is_expected.to eq("Content-Type" => content_type) }
    its(:parsed_body) { is_expected.to eq("test" => true) }
    its(:raw_body) { is_expected.to eq("{\"test\":true}") }
    its(:meta) { is_expected.to eq({}) }
  end
end
