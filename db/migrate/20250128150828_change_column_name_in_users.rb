class ChangeColumnNameInUsers < ActiveRecord::Migration[7.2]
  def change
    rename_column :users, :password_salt, :salt
  end
end
