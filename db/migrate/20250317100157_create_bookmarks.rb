class CreateBookmarks < ActiveRecord::Migration[7.2]
  def change
    create_table :bookmarks do |t|
      t.references :user, foreign_key: true
      t.references :store, foreign_key: true

      t.timestamps
    end
    add_index :bookmarks, [ :user_id, :store_id ], unique: true
  end
end
