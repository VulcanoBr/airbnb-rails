class Listing < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user
  has_many :bookings
  has_rich_text :description
  has_many_attached :images
end
