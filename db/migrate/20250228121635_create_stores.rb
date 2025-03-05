class CreateStores < ActiveRecord::Migration[7.2]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :address
      t.string :phone_number
      t.string :web_site
      t.string :place_id, null: false

      t.timestamps
    end
  end
end
