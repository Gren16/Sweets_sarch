class Store < ApplicationRecord
  validates :name, :address, :phone_number, :place_id, :latitude, :longitude, presence: true

  belongs_to :user, optional: true
  has_many :bookmarks, dependent: :destroy
end
