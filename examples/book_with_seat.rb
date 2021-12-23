# frozen_string_literal: true

require "duffel_api"

client = DuffelAPI::Client.new(
  access_token: ENV["DUFFEL_ACCESS_TOKEN"],
)

# 365 days from now
departure_date = (Time.now + (60 * 60 * 24 * 365)).strftime("%Y-%m-%d")

offer_request = client.offer_requests.create(params: {
  cabin_class: "economy",
  passengers: [{
    age: 28,
  }],
  slices: [{
    # We use a non-sensical route to make sure we get speedy, reliable Duffel Airways
    # results.
    origin: "LGA",
    destination: "JFK",
    departure_date: departure_date,
  }],
  # This attribute is sent as a query parameter rather than in the body like the others.
  # Worry not! The library handles this complexity for you.
  return_offers: false,
})

puts "Created offer request: #{offer_request.id}"

offers = client.offers.all(params: { offer_request_id: offer_request.id })

puts "Got #{offers.count} offers"

selected_offer = offers.first

puts "Selected offer #{selected_offer.id} to book"

priced_offer = client.offers.get(selected_offer.id,
                                 params: { return_available_services: true })

puts "The final price for offer #{priced_offer.id} is #{priced_offer.total_amount} " \
     "#{priced_offer.total_currency}"

seat_maps = client.seat_maps.list(params: { offer_id: priced_offer.id })

available_seat = seat_maps.records.first.cabins.
  first["rows"].
  flat_map { |row| row["sections"] }.
  flat_map { |section| section["elements"] }.
  find do |element|
  element["type"] == "seat" && element["available_services"].any?
end

available_seat_service = available_seat["available_services"].first

puts "Adding seat #{available_seat['designator']} costing " \
     "#{available_seat_service['total_amount']} " \
     "#{available_seat_service['total_currency']}"

total_amount = priced_offer.total_amount.to_f +
  available_seat_service["total_amount"].to_f

order = client.orders.create(params: {
  selected_offers: [priced_offer.id],
  services: [{
    id: available_seat_service["id"],
    quantity: 1,
  }],
  payments: [
    {
      type: "balance",
      amount: total_amount,
      currency: priced_offer.total_currency,
    },
  ],
  passengers: [
    {
      id: priced_offer.passengers.first["id"],
      title: "mr",
      gender: "m",
      given_name: "Tim",
      family_name: "Rogers",
      born_on: "1993-04-01",
      phone_number: "+441290211999",
      email: "tim@duffel.com",
    },
  ],
})

puts "Created order #{order.id} with booking reference #{order.booking_reference}"
