class CreateSpellcastings < ActiveRecord::Migration[5.2]
  def change
    create_table :spellcastings do |t|
      t.string :ability
      t.belongs_to :player_class, foreign_key: true
      t.integer :level
      t.text :info

      t.timestamps
    end
  end
end
