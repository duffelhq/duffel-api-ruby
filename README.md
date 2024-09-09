> [!WARNING] 
> This client library is not currently being supported by Duffel due to a lack of adoption.
> 
> You're welcome to fork the repositories and continue maintaining them for your own use.
>
> If, in the future, there's sufficient demand for a particular client library, we'll reconsider our decision to officially support it.

---

# Duffel API Ruby client library

[![RubyDoc.info documentation](http://img.shields.io/badge/yard-docs-blue.svg)](https://rubydoc.info/github/duffelhq/duffel-api-ruby)

A Ruby client library for the [Duffel API](https://duffel.com/docs/api).

## Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)

## Requirements

* Ruby 2.6 or later
* A Duffel API access token (get started [here](https://duffel.com/docs/guides/quick-start) ✨)

## Installation

In most cases, you'll want to add `duffel_api` to your project as a dependency by listing it in your `Gemfile`, and then running `bundle`:

```ruby
gem "duffel_api", "~> 0.4.0"
```

You can install `duffel_api` outside of the context of a project by running `gem install duffel_api` - for example if you want to play with the client library in `irb`.

## Usage

You can see a complete end-to-end example of searching and booking using the client library in [`example/search_and_book.rb`](https://github.com/duffelhq/duffel-api-ruby/blob/main/examples/search_and_book.rb).

### Initialising the client

All of the library's functionality is accessed from a `DuffelAPI::Client` instance.

To initialise a `DuffelAPI::Client`, all you'll need is your API access token:

```ruby
require "duffel_api"

client = DuffelAPI::Client.new(access_token: "duffel_test_000000000")
```

### Resources in the Duffel API

In this readme, we'll use the term "resources" to refer to the different Duffel concepts that you can *act on* in the API - for example airports, offers, orders and payment intents.

We'll refer to instances of each of these resources - an airport, an offer, a payment intent - as "records".

In the [Duffel API reference](https://duffel.com/docs/api/), the resources are listed in the sidebar. For each resource, you'll find:

* a schema, which describes the data attributes we expose for each record from this resource
* a list of actions you can perform related to that resource (e.g. for [Orders](https://duffel.com/docs/api/orders), you can "Get a single order", "Update a single order", "List orders" and "Create an order")

The Ruby client library is structured around these resources. Each resource has its own "service" which you use to perform actions. These services are accessible from your `Client` instance:

```ruby
client.orders
client.offers
client.payment_intents
```

__To see what actions are available for each resource, check out the definitions for the service classes [here](https://github.com/duffelhq/duffel-api-ruby/tree/main/lib/duffel_api/services).__

### Creating a record

Most resources allow you to create a record. In fact, the most important flows in the Duffel API start with creating a record. You'll do this with the `#create` method exposed on a service.

For example, you'll search for flights by creating an offer request:

```ruby
offer_request = client.offer_requests.create(params: {
  cabin_class: "economy",
  passengers: [{
    age: 28
  }],
  slices: [{
    origin: "LHR",
    destination: "NYC",
    departure_date: "2022-12-31"
  }],
  # This attribute is sent as a query parameter rather than in the body like the others.
  # Worry not! The library handles this complexity for you.
  return_offers: false
})

puts "You've created an offer request, #{offer_request.id}."
```

The `#create` method returns the created record.

### Listing records

Many resources in the Duffel API (e.g. airports, orders and offers) allow you to list their records.

For example, you can get a list of all the airports that Duffel knows about - that is, a list of airport records.

For performance reasons, we [paginate](https://duffel.com/docs/api/overview/pagination) records in the API when listing. You can only see up to 200 at a time. You'll need to page through, like moving through pages of a book.

This is quite fiddly, so the client library does it for you in the `#all` method exposed by relevant services. All you have to do is something like this:

```ruby
client.offer_requests.all.each do |offer_request|
  puts "Loaded offer request #{order_request.id}"
end
```

Sometimes, you'll want to specify filters or sort orders when listing,like this:

```ruby
# The filters you can use for a given resource are documented in the API Reference
client.offers.
  all(params: { offer_request_id: "ofr_123", sort: "total_amount" }).
  each do |order|
    puts "Loaded order #{order.id}"
  end
```

A call to `#all` returns a Ruby [`Enumerator`](https://ruby-doc.org/core-2.6/Enumerator.html), which behaves a lot like an array - you can get the number of records with `#length`, loop through it with `#each`, etc.

If you prefer, you can also page through records manually using a service's `#list` method (e.g. `client.orders.list`) which returns a `DuffelAPI::ListResponse`.

The records in the page are returned by `#records` (`client.orders.list.records`) and the cursor for the next page (if there is one) can be found with `#after` (`client.orders.list.after`)

#### An exception: seat maps

Watch out! There is one kind of list in the Duffel API which isn't paginated: seat maps.

When you call `client.seat_maps.list(params: { offer_id: "off_123" })`, all of the seat maps will be returned at once in a single `ListResponse`.

### Fetching single records

Many resources in the Duffel API allow you fetch a single record (e.g. *an* airport, *a* payment intent) if you know its ID.

You do that using the `#get` method on a resource like this:

```ruby
order = client.orders.get("ord_123")
puts "Your booking reference is #{order.booking_reference}."
```

The `#get` method returns the record.

### Updating a record

Some records in the Duffel API allow you to update them after they've been created, if you know their ID.

That works like this using the `#update` method on a resource:

```ruby
client.webhooks.update("sev_0000AEdmUJKCvFK45qMFBg", params: {
  active: false
})
```

The `#update` method returns the updated record.

### Performing an action on a record

Some resources allow you to perform special actions on their records - for example confirming an order cancellation or pinging a webhook.

The methods you'll use to do this aren't named consistently, because each resource has different actions. For example, you'll call `#confirm` to confirm an order cancellation but `#ping` to ping a webhook.

It'll look a bit like this:

```ruby
client.order_cancellations.confirm("ore_0000AEUvjGoJlav2j6FDlZ")
```

Sometimes, you'll need to pass extra data when performing the action. That works like this:

```ruby
client.order_changes.confirm("oce_0000AEdlOBVlABkDhgsUqW", params: {
  payment: {
    type: "balance",
    currency: "GBP",
    amount: "125.00",
  }
})
```

In general, these action methods return the record you've acted on.

#### An exception: pinging a webhook

Watch out! There is one action in the API which doesn't return the record you've acted on.

When you ping a webhook with `client.webhooks.ping("sev_0000AEdmUJKCvFK45qMFBg")`, it'll return a `DuffelAPI::Services::WebhooksService::PingResult` if successful, or otherwise it'll raise an error.

### Handling errors

When the Duffel API returns an error, the library will raise an exception.

We have an exception class for each of the possible `type`s of error which the API can return, documented [here](https://duffel.com/docs/api/overview/errors) in the API reference. For example, if the API returns an error with `type` `invalid_state_error`, the library will raise a `DuffelAPI::Errors::InvalidStateError` exception.

You can find all of those error classes [here](https://github.com/duffelhq/duffel-api-ruby/tree/main/lib/duffel_api/errors).

You can rescue all of these errors and get important information with them using instances methods: `#message`, `#title`, `#code`, `#request_id`, etc.

If the client library is unable to connect to Duffel, an appropriate exception will be raised, for example:

* `Faraday::TimeoutError` in case of a timeout
* `Faraday::ConnectionFailed` in case of a connection issue (e.g. problems with DNS resolution)
* `DuffelAPI::Errors::Error` for `5XX` errors returned from by Duffel's infrastructure, but not by the API itself (e.g. a load balancer)

### Accessing the raw API response

Sometimes, you might want to get lower-level details about the response you received from the Duffel API - for example the raw body or headers.

If an error has been raised, you can call `#api_response` on the exception, which returns a `DuffelAPI::APIResponse`. If you're looking at a `ListResponse` or any resource, you can call `#api_response` on that.

From the `APIResponse`, you can call `#headers`, `#status_code`, `#raw_body`, `#parsed_body`, `#meta` or `#request_id` to get key information from the response.

### Verifying webhooks

You can set up [webhooks](https://duffel.com/docs/guides/receiving-webhooks) with Duffel to receive notifications about events that happen in your Duffel account - for example, when an airline has a schedule change affecting one of your orders.

These webhook events are signed with a shared secret. This allows you to be sure that any webhook events are genuinely sent from Duffel when you receive them.

When you create a webhook, you'll set a secret. With that secret in mind, you can verify that a webhook is genuine like this:

```ruby
# In Rails, you'd get this with `request.raw_post`.
request_body = '{"created_at":"2022-01-08T18:44:56.129339Z","data":{"changes":{},"object":{}},"id":"eve_0000AFEsrBKZAcKgGtZCnQ","live_mode":false,"object":"order","type":"order.updated"}'
# In Rails, you'd get this with `request.headers['X-Duffel-Signature']`.
request_signature = "t=1641667496,v1=691f25ffb1f206c0fda5bb7b1a9d60fafe42c5f42819d44a06a7cfe09486f102"

# Note that this code doesn't require your access token - `DuffelAPI::WebhookEvent`
# doesn't expect you to have a `Client` initialised
if DuffelAPI::WebhookEvent.genuine?(
  request_body: request_body,
  request_signature: request_signature,
  webhook_secret: "a_secret"
)
  puts "This is a real webhook from Duffel 🌟"
else
  puts "This is a fake webhook! ☠️"
end
```

## Learn more

You can find complete documentation on this library's classes and methods in the in-code
documentation on [RubyDoc.info](https://rubydoc.info/github/duffelhq/duffel-api-ruby).
