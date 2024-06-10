class Booking < ApplicationRecord
  belongs_to :listing
  belongs_to :user

  enum :status, ["pending", "complete"]

  validate :checkout_dates_valid, :listing_is_available

  def amount_of_days
    (checkout_date.to_date - checkin_date.to_date).to_i
  end

  private

  def checkout_dates_valid
    if checkout_date <= checkin_date
      errors.add(:checkout_date, "Must be more than 1 day after check in")
    end
  end

  def listing_is_available
    if Booking.complete.where(listing_id: listing_id).where("checkin_date <= ? and checkout_date > ?", checkin_date, checkin_date).any?
      errors.add(:checkin_date, "Is already booked for this Listing")
    end
  end
end
