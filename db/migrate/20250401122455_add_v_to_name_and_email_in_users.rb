class AddVToNameAndEmailInUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :name, false
    change_column_null :users, :email, false
  end
end
