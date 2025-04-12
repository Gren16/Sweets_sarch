class Store < ApplicationRecord
  validates :name, :address, :phone_number, :place_id, :latitude, :longitude, presence: true

  belongs_to :user, optional: true
  has_many :bookmarks, dependent: :destroy

  def self.ransackable_associations(auth_object = nil)
    [ "bookmarks", "user" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "name", "address", "phone_number", "latitude", "longitude", "place_id", "web_site" ]
  end
end
