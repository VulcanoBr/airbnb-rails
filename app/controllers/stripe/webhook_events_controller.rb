module Stripe
  class WebhookEventsController < ApplicationController
    skip_forgery_protection
    def create
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = nil
  
      begin
          event = Stripe::Webhook.construct_event(
              payload, sig_header, Rails.application.credentials.dig(:stripe, :wh_secret)
          )
      rescue JSON::ParserError => e
          # Invalid payload
          status 400
          return
      rescue Stripe::SignatureVerificationError => e
          # Invalid signature
          status 400
          return
      end

      case event.type
      when 'account.updated'
          webhook_event = WebhookEvent.create(event_id: event.id, data: event)
          AccountUpdatedJob.perform_later(webhook_event.id)
      when 'checkout.session.completed'
        webhook_event = WebhookEvent.create(event_id: event.id, data: event)
        BookingCompleteJob.perform_later(webhook_event.id)
      else
          puts "Unhandled event type: #{event.type}"
      end
    end
  end
end