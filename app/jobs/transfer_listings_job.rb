class TransferListingsJob < ApplicationJob
  queue_as :default

  def perform from_date, to_date
    from = Date.parse(from_date)
    to   = to_date.present? ? Date.parse(to_date) : (from + 1.month)
    listings = Listing.between(from, to)
    Listing.transfer_to_past_listings_table(listings)
  end
end
