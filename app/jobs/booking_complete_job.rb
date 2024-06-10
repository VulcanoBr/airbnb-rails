class BookingCompleteJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    webhook_event = WebhookEvent.find(event_id)
    stripe_object = Stripe::Util.convert_to_stripe_object(webhook_event.data)
    booking_id = stripe_object.data.object.metadata.booking_id
    if booking_id
      booking = Booking.find(booking_id)
      booking.complete!
    end
  end
end
