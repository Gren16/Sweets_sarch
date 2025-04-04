class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: true
  validates :reset_password_token, uniqueness: true, allow_nil: true

  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_stores, through: :bookmarks, source: :store
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications


  def own?(object)
    id == object&.user_id
  end

  def bookmark(store)
    bookmark_stores << store
  end

  def unbookmark(store)
    bookmark_stores.destroy(store)
  end

  def bookmark?(store)
    bookmark_stores.include?(store)
  end
end
