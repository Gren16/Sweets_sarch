require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションチェック" do
    it "設定したすべてのバリデーションが機能しているか" do
      user = create(:user, password: "password123", password_confirmation: "password123")
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it "emailが被らない場合にバリデーションエラーが起きないか" do
      user = User.create(email: "test@example.com")
      user_with_another_user = build(:user, email: "user@example.com", password: "password123", password_confirmation: "password123")

      expect(user_with_another_user).to be_valid
      expect(user_with_another_user.errors).to be_empty
    end

    context "新規ユーザー作成時" do
      it "passwordが6文字未満の場合、無効になる" do
        user = build(:user, password: "Pass1", password_confirmation: "Pass1")
        user.password = "Pass1"
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("は6文字以上で入力してください")
      end

      it "passwordが6文字以上の場合、有効になる" do
        user = build(:user, password: "Password123", password_confirmation: "Password123")
        expect(user).to be_valid
      end
    end

    context "既存ユーザーのパスワード変更時" do
      it "passwordが6文字未満の場合、無効になる" do
        user = create(:user, password: "Pass1", password_confirmation: "Pass1")
        user.password = "Pass1"
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("は6文字以上で入力してください")
      end

      it "passwordが6文字以上の場合、有効になる" do
        user = create(:user, password: "Password123", password_confirmation: "Password123")  # まず有効なパスワードでユーザー作成
        user.password = "Password124"
        user.password_confirmation = "Password124"
        expect(user).to be_valid
      end
    end

    it "password_confirmationが一致しておらずバリデーションが機能してinvalidになるか" do
      user = build(:user, password: "password123", password_confirmation: "different_password")

      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end

    it "password_confirmationが空の場合バリデーションが機能してinvalidになるか" do
      user = build(:user, password: "password123", password_confirmation: nil)

      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("を入力してください")
    end

    it "nameが空の場合バリデーションが機能してinvalidになるか" do
      user = build(:user, name: nil)

      expect(user).not_to be_valid
      expect(user.errors[:name]).to eq [ "を入力してください" ]
    end

    it "nameが20文字以下になっていない場合バリデーションが機能してinvalidになるか" do
      long_name = "a" * 21
      user = build(:user, name: long_name)

      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("は20文字以内で入力してください")
    end

    it "emailが空の場合バリデーションが機能してinvalidになるか" do
      user = build(:user, email: nil)

      expect(user).not_to be_valid
      expect(user.errors[:email]).to eq [ "を入力してください" ]
    end

    it "emailが被った場合uniquenessのバリデーションが機能してinvalidになるか" do
      user = create(:user, email: "test@example.com", password: "123456", password_confirmation: "123456")
      user_with_another_user = build(:user, email: "test@example.com", password: "123456", password_confirmation: "123456")

      expect(user_with_another_user).not_to be_valid
      expect(user_with_another_user.errors[:email]).to eq [ "はすでに存在します" ]
    end
  end
end
