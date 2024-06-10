class AccountUpdatedJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    webhook_event = WebhookEvent.find(event_id)
    stripe_object = Stripe::Util.convert_to_stripe_object(webhook_event.data)
    if stripe_object.data.object.charges_enabled
      user = User.find_by_stripe_account_id(stripe_object.data.object.id)
      user.update(stripe_status: :complete)
    end
  end
end
