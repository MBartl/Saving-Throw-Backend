class CreateCharacterSpells < ActiveRecord::Migration[5.2]
  def change
    create_table :character_spells do |t|
      t.belongs_to :character, foreign_key: true
      t.belongs_to :spell, foreign_key: true

      t.timestamps
    end
  end
end
