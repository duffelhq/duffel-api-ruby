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

    let(:response_headers) do
      {
        "Content-Type" => "application/json",
        "X-Request-Id" => "FsJz79144I4JjDwAA6TB",
      }
    end

    let(:stubbed) do
      Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get("/testing") do |_env|
          [200, response_headers, { test: true }.to_json]
        end
      end
    end
    let(:test) { Faraday.new { |builder| builder.adapter :test, stubbed } }

    its(:status_code) { is_expected.to eq(200) }
    its(:headers) { is_expected.to eq(response_headers) }
    its(:body) { is_expected.to eq("{\"test\":true}") }
    its(:request_id) { is_expected.to eq("FsJz79144I4JjDwAA6TB") }
  end
end
