class AddStripeStatusToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :stripe_status, :integer, default: 0
  end
end
