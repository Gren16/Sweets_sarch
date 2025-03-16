class AddUniqueIndexToStoresPlaceId < ActiveRecord::Migration[7.2]
  def change
    add_index :stores, :place_id, unique: true
  end
end
