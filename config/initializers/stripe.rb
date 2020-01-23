Stripe.api_key 						 = ENV["STRIPE_API_KEY"]
STRIPE_PUBLIC_KEY 				 = ENV["STRIPE_PUBLIC_KEY"]
StripeEvent.signing_secret = ENV['STRIPE_SIGNING_SECRET']

StripeEvent.configure do |events|
  events.subscribe 'invoice.', Stripe::InvoiceEventHandler.new
  events.subscribe 'charge.', Stripe::ChargeEventHandler.new
end