# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Client do
  subject { described_class.new(access_token: "secret_token") }

  its(:aircraft) { is_expected.to be_a(DuffelAPI::Services::AircraftService) }
  its(:airlines) { is_expected.to be_a(DuffelAPI::Services::AirlinesService) }
  its(:airports) { is_expected.to be_a(DuffelAPI::Services::AirportsService) }

  its(:offer_passengers) do
    is_expected.to be_a(DuffelAPI::Services::OfferPassengersService)
  end

  its(:offer_requests) { is_expected.to be_a(DuffelAPI::Services::OfferRequestsService) }
  its(:offers) { is_expected.to be_a(DuffelAPI::Services::OffersService) }

  its(:order_cancellations) do
    is_expected.to be_a(DuffelAPI::Services::OrderCancellationsService)
  end

  its(:order_change_offers) do
    is_expected.to be_a(DuffelAPI::Services::OrderChangeOffersService)
  end

  its(:order_change_requests) do
    is_expected.to be_a(DuffelAPI::Services::OrderChangeRequestsService)
  end

  its(:order_changes) do
    is_expected.to be_a(DuffelAPI::Services::OrderChangesService)
  end

  its(:orders) { is_expected.to be_a(DuffelAPI::Services::OrdersService) }

  its(:payment_intents) do
    is_expected.to be_a(DuffelAPI::Services::PaymentIntentsService)
  end

  its(:payments) { is_expected.to be_a(DuffelAPI::Services::PaymentsService) }
  its(:refunds) { is_expected.to be_a(DuffelAPI::Services::RefundsService) }
  its(:seat_maps) { is_expected.to be_a(DuffelAPI::Services::SeatMapsService) }
  its(:webhooks) { is_expected.to be_a(DuffelAPI::Services::WebhooksService) }
end
