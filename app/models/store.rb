class Store < ApplicationRecord
  validates :name, :address, :phone_number, :place_id, presence: true
end

