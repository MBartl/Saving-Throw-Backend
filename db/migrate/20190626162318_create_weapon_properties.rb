class CreateWeaponProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :weapon_properties do |t|
      t.belongs_to :equipment
      t.string :name
      t.text :desc

      t.timestamps
    end
  end
end
