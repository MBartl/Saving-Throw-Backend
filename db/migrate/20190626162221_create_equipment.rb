class CreateEquipment < ActiveRecord::Migration[5.2]
  def change
    create_table :equipment do |t|
      t.string :name
      t.string :equipment_category
      t.string :equipment_subcategory
      t.string :cost
      t.text :details
      t.string :weapon_range
      t.string :capacity
      t.string :speed
      t.integer :weight

      t.timestamps
    end
  end
end
