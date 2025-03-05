class Store < ApplicationRecord
  validates :name, :address, :phone_number, :place_id, presence: true
  validates :web_site, format: { with: URI::regexp(%w[http https]), message: "must be a valid URL" }
end
