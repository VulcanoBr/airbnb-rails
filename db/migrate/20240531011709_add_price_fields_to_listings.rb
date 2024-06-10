class AddPriceFieldsToListings < ActiveRecord::Migration[7.1]
  def change
    add_column :listings, :day_price, :decimal
    add_column :listings, :weekly_price, :decimal
    add_column :listings, :monthly_price, :decimal
  end
end
