class CreatePlayerClasses < ActiveRecord::Migration[5.2]
  def change
    create_table :player_classes do |t|
      t.string :name
      t.integer :hit_die
      t.string :saving_throws
      t.text :starting_equipment
      t.text :class_levels

      t.timestamps
    end
  end
end
