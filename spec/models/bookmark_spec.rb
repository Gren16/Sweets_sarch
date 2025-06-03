require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  let(:user) { create(:user, password: "Password123", password_confirmation: "Password123") }
  let(:store) { create(:store) }
  let(:bookmark) { build(:bookmark, user: user, store: store) }

  it "user_idとstore_idがあれば有効であること" do
    bookmark = Bookmark.new(user_id: user.id, store_id: store.id)
    expect(bookmark).to be_valid
  end

  describe "バリデーションのテスト" do
    it "user_idとstore_idがあれば有効であること" do
      expect(bookmark).to be_valid
    end

    it "同じuser_idとstore_idの組み合わせは無効であること" do
      create(:bookmark, user: user, store: store)
      duplicate_bookmark = build(:bookmark, user: user, store: store)
      expect(duplicate_bookmark).not_to be_valid
      expect(duplicate_bookmark.errors[:user_id]).to include("はすでに存在します")
    end

    it "user_idがない場合は無効であること" do
      bookmark.user = nil
      expect(bookmark).not_to be_valid
    end

    it "store_idがない場合は無効であること" do
      bookmark.store = nil
      expect(bookmark).not_to be_valid
    end
  end

  describe "アソシエーションのテスト" do
    it "ユーザーに関連付けられていること" do
      expect(bookmark).to respond_to(:user)
    end

    it "店舗に関連付けられていること" do
      expect(bookmark).to respond_to(:store)
    end
  end

  describe "インスタンスメソッドのテスト" do
    it "store_nameメソッドが店舗名を返すこと" do
      store.name = "スイーツカフェ"
      store.save
      expect(bookmark.store_name).to eq("スイーツカフェ")
    end
  end
end
