class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :store

  validates :user_id, uniqueness: { scope: :store_id }

  def store_name
    store.name
  end
end
