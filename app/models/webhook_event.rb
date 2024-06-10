class WebhookEvent < ApplicationRecord
  serialize :data, coder: JSON
end
