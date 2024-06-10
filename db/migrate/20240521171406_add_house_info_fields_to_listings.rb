class AddHouseInfoFieldsToListings < ActiveRecord::Migration[7.1]
  def change
    add_column :listings, :bedrooms, :integer
    add_column :listings, :bathrooms, :integer
    add_column :listings, :people_limit, :integer
  end
end
