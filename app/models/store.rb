class Store < ApplicationRecord
  validates :name, :address, :phone_number, :place_id, presence: true

  belongs_to :user
  has_many :bookmarks, dependent: :destroy
end
