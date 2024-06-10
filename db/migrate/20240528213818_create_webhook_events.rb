class CreateWebhookEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :webhook_events do |t|
      t.text :data
      t.string :event_id

      t.timestamps
    end
  end
end
