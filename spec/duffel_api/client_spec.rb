# frozen_string_literal: true

require "spec_helper"

describe DuffelAPI::Client do
  subject { described_class.new(access_token: "secret_token") }

  its(:aircraft) { is_expected.to be_a(DuffelAPI::Services::AircraftService) }
  its(:airlines) { is_expected.to be_a(DuffelAPI::Services::AirlinesService) }
  its(:airports) { is_expected.to be_a(DuffelAPI::Services::AirportsService) }
  its(:offer_requests) { is_expected.to be_a(DuffelAPI::Services::OfferRequestsService) }
  its(:offers) { is_expected.to be_a(DuffelAPI::Services::OffersService) }
  its(:orders) { is_expected.to be_a(DuffelAPI::Services::OrdersService) }
  its(:payments) { is_expected.to be_a(DuffelAPI::Services::PaymentsService) }
  its(:seat_maps) { is_expected.to be_a(DuffelAPI::Services::SeatMapsService) }
end
