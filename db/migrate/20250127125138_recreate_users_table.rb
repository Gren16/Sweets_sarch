class RecreateUsersTable < ActiveRecord::Migration[7.2]
  def up
    drop_table :users if ActiveRecord::Base.connection.table_exists?(:users)

    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :crypted_password
      t.string :password_salt

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
