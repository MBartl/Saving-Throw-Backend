class CreateRaces < ActiveRecord::Migration[5.2]
  def change
    create_table :races do |t|
      t.string :name
      t.integer :speed
      t.string :ability_bonuses
      t.text :alignment
      t.text :age
      t.string :size
      t.text :size_desc
      t.string :languages
      t.text :language_desc

      t.timestamps
    end
  end
end
