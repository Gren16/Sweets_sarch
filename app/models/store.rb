class Store < ApplicationRecord
  validates :name, :address, :phone_number, :place_id, :latitude, :longitude, presence: true

  belongs_to :user, optional: true
  has_many :bookmarks, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ["address", "created_at", "id", "latitude", "longitude", "name", "phone_number", "place_id", "updated_at", "user_id", "web_site"]
  end
end
