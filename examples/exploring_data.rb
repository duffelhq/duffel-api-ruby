# frozen_string_literal: true

require "duffel_api"

client = DuffelAPI::Client.new(
  access_token: ENV["DUFFEL_ACCESS_TOKEN"],
)

puts "Loading airports..."

airports = client.airports.all

puts "Got #{airports.count} airports"

puts "Found airport #{airports.first.name} (#{airports.first.iata_code})"

airport = client.airports.get(airports.first.id)

puts "Airport is located at #{airport.latitude}, #{airport.longitude}"

puts "Loading aircraft..."

aircraft = client.aircraft.all

puts "Got #{aircraft.count} aircraft"

puts "Found aircraft #{aircraft.first.name}"

single_aircraft = client.aircraft.get(aircraft.first.id)

puts "Aircraft's IATA code is #{single_aircraft.iata_code}"

puts "Loading airlines..."

airlines = client.airlines.all

puts "Got #{airlines.count} airlines"

puts "Found airline #{airlines.first.name}"

airline = client.airlines.get(airlines.first.id)

puts "Airline's IATA code is #{airline.iata_code}"
