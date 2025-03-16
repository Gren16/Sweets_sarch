require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションチェック" do
    it "設定したすべてのバリデーションが機能しているか" do
      user = create(:user, password: "password", password_confirmation: "password")
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it "emailが被らない場合にバリデーションエラーが起きないか" do
      user = User.create(email: "test@example.com")
      user_with_another_user = build(:user, email: "user@example.com", password: "password", password_confirmation: "password")

      expect(user_with_another_user).to be_valid
      expect(user_with_another_user.errors).to be_empty
    end

    context "新規ユーザー作成時" do
      it "passwordが6文字未満の場合、無効になる" do
        user = build(:user, password: "12345", password_confirmation: "123456")
        user.password = "12345"
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
      end

      it "passwordが6文字以上の場合、有効になる" do
        user = build(:user, password: "123456", password_confirmation: "123456")
        expect(user).to be_valid
      end
    end

    context "既存ユーザーのパスワード変更時" do
      it "passwordが6文字未満の場合、無効になる" do
        user = create(:user, password: "123456", password_confirmation: "123456")
        user.password = "12345"
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
      end

      it "passwordが6文字以上の場合、有効になる" do
        user = create(:user, password: "123456", password_confirmation: "123456")  # まず有効なパスワードでユーザー作成
        user.password = "1234567"
        user.password_confirmation = "1234567"
        expect(user).to be_valid
      end
    end

    it "password_confirmationが一致しておらずバリデーションが機能してinvalidになるか" do
      user = build(:user, password: "password123", password_confirmation: "different_password")

      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it "password_confirmationが空の場合バリデーションが機能してinvalidになるか" do
      user = build(:user, password: "password123", password_confirmation: nil)

      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("can't be blank")
    end

    it "nameが空の場合バリデーションが機能してinvalidになるか" do
      user = build(:user, name: nil)

      expect(user).not_to be_valid
      expect(user.errors[:name]).to eq [ "can't be blank" ]
    end

    it "nameが20文字以下になっていない場合バリデーションが機能してinvalidになるか" do
      long_name = "a" * 21
      user = build(:user, name: long_name)

      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("is too long (maximum is 20 characters)")
    end

    it "emailが空の場合バリデーションが機能してinvalidになるか" do
      user = build(:user, email: nil)

      expect(user).not_to be_valid
      expect(user.errors[:email]).to eq [ "can't be blank" ]
    end

    it "emailが被った場合uniquenessのバリデーションが機能してinvalidになるか" do
      user = create(:user, email: "test@example.com", password: "123456", password_confirmation: "123456")
      user_with_another_user = build(:user, email: "test@example.com", password: "123456", password_confirmation: "123456")

      expect(user_with_another_user).not_to be_valid
      expect(user_with_another_user.errors[:email]).to eq [ "has already been taken" ]
    end
  end
end
