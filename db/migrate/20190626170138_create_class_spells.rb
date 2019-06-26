class CreateClassSpells < ActiveRecord::Migration[5.2]
  def change
    create_table :class_spells do |t|
      t.belongs_to :player_class, foreign_key: true
      t.belongs_to :subclass, foreign_key: true
      t.belongs_to :spell, foreign_key: true

      t.timestamps
    end
  end
end
