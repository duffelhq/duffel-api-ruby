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

priced_offer = client.offers.get(selected_offer.id,
                                 params: { return_available_services: true })

puts "The final price for offer #{priced_offer.id} is #{priced_offer.total_amount} " \
     "#{priced_offer.total_currency}"

order = client.orders.create(params: {
  type: "hold",
  selected_offers: [priced_offer.id],
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

puts "Created hold order #{order.id} with booking reference #{order.booking_reference}"

updated_order = client.orders.get(order.id)

puts "Retrieved order and up-to-date price is #{updated_order.total_amount} " \
     "#{updated_order.total_currency}"

payment = client.payments.create(params: {
  order_id: order.id,
  payment: {
    type: "balance",
    amount: updated_order.total_amount,
    currency: updated_order.total_currency,
  },
})

puts "Paid for order #{order.id} with payment #{payment.id}"

paid_order = client.orders.get(order.id)

puts "After payment, order has #{paid_order.documents.length} documents"
