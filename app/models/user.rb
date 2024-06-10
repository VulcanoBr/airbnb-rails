class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_rich_text :about_me
  has_one_attached :profile_picture
  has_many :listings
  has_many :bookings
  enum :stripe_status, ["pending", "complete"]
  
  def create_stripe_account
    stripe_account = Stripe::Account.create
    update(stripe_account_id: stripe_account["id"])
  end

  def upcoming_bookings(listing = nil)
    @bookings ||= find_upcoming_bookings(listing)
  end

  private

  def find_upcoming_bookings(listing = nil)
    query = { status: 'complete', checkout_date: Time.now.. }
    query["listing_id"] = listing.id if listing
    bookings.where(query)
  end
end
