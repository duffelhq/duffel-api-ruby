# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Errors::Error do
  subject(:error) { described_class.new(returned_error, response) }

  let(:returned_error) { JSON.parse(error_response)["errors"].first }
  let(:response) { DuffelAPI::Response.new(faraday_connection.get("/testing")) }

  let(:stubbed_faraday_adapter) do
    Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get("/testing") do |_env|
        [200, { "Content-Type" => "application/json" }, error_response]
      end
    end
  end

  let(:faraday_connection) do
    Faraday.new do |builder|
      builder.adapter :test, stubbed_faraday_adapter
    end
  end

  let(:error_response) do
    load_fixture("validation_error.json")
  end

  its(:documentation_url) do
    is_expected.to eq("https://duffel.com/docs/api/overview/errors")
  end

  its(:title) { is_expected.to eq("Required field") }
  its(:message) { is_expected.to eq("Field 'slices' can't be blank") }
  its(:type) { is_expected.to eq("validation_error") }
  its(:code) { is_expected.to eq("validation_required") }

  its(:source) do
    is_expected.to eq({
      "field" => "slices", "pointer" => "/slices"
    })
  end

  its(:api_response) { is_expected.to be_a(DuffelAPI::APIResponse) }

  context "when instantiating with a string" do
    it "raises an ArgumentError" do
      expect { described_class.new("FOO") }.to raise_error(ArgumentError)
    end
  end
end
