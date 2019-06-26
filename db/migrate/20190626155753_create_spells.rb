class CreateSpells < ActiveRecord::Migration[5.2]
  def change
    create_table :spells do |t|
      t.string :name
      t.text :desc
      t.integer :level
      t.text :higher_level
      t.string :range
      t.string :components
      t.text :material
      t.string :duration
      t.boolean :ritual
      t.boolean :concentration
      t.string :casting_time
      t.string :school

      t.timestamps
    end
  end
end
