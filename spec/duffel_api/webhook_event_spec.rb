# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::WebhookEvent do
  describe ".genuine?" do
    subject(:is_genuine) do
      described_class.genuine?(request_body: request_body,
                               request_signature: request_signature,
                               webhook_secret: webhook_secret)
    end

    let(:request_body) do
      '{"created_at":"2022-01-08T18:44:56.129339Z","data":{"changes":{},"object":{}},' \
        '"id":"eve_0000AFEsrBKZAcKgGtZCnQ","live_mode":false,"object":"order","type":"' \
        'order.updated"}'
    end
    let(:webhook_secret) { "a_secret" }
    let(:request_signature) do
      "t=1641667496,v1=691f25ffb1f206c0fda5bb7b1a9d60fafe42c5f42819d44a06a7cfe09486f102"
    end

    it { is_expected.to be(true) }

    context "when the signature doesn't look like a real signature at all" do
      let(:request_signature) { "nah" }

      it { is_expected.to be(false) }
    end

    context "when the signature doesn't match the body" do
      let(:request_body) { "foo" }

      it { is_expected.to be(false) }
    end
  end
end
