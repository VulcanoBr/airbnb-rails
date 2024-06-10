class AddUserToListings < ActiveRecord::Migration[7.1]
  def change
    add_reference :listings, :user, null: true, foreign_key: true
  end
end
