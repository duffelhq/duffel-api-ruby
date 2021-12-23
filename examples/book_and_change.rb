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
    origin: "LHR",
    destination: "STN",
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

priced_offer = client.offers.get(selected_offer.id)

puts "The final price for offer #{priced_offer.id} is #{priced_offer.total_amount} " \
     "#{priced_offer.total_currency}"

order = client.orders.create(params: {
  selected_offers: [priced_offer.id],
  payments: [
    {
      type: "balance",
      amount: priced_offer.total_amount,
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

order_change_request = client.order_change_requests.create(params: {
  order_id: order.id,
  slices: {
    add: [{
      cabin_class: "economy",
      departure_date: "2022-12-25",
      origin: "LHR",
      destination: "STN",
    }],
    remove: [{
      slice_id: order.slices.first["id"],
    }],
  },
})

order_change_offers = client.order_change_offers.
  all(params: { order_change_request_id: order_change_request.id })

puts "Got #{order_change_offers.count} options for changing the order; picking first " \
     "option"

order_change = client.order_changes.create(params: {
  selected_order_change_offer: order_change_offers.first.id,
  order_id: order.id,
})

puts "Created order change #{order_change.id}, confirming..."

client.order_changes.confirm(order_change.id, params: {
  payment: {
    type: "balance",
    amount: order_change.change_total_amount,
    currency: order_change.change_total_currency,
  },
})

puts "Processed change to order #{order.id} costing " \
     "#{order_change.change_total_amount} #{order_change.change_total_currency}"
