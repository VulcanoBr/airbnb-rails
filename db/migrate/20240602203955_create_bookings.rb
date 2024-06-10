class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.belongs_to :listing, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :checkin_date
      t.datetime :checkout_date

      t.timestamps
    end
  end
end
