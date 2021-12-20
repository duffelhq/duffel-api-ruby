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

    specify { expect(api_response.status_code).to be(200) }

    specify do
      expect(api_response.headers).to eql("Content-Type" => content_type)
    end

    specify { expect(api_response.body).to eql("test" => true) }
  end
end
