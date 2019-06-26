class CreateCharacterProficiencyChoices < ActiveRecord::Migration[5.2]
  def change
    create_table :character_proficiency_choices do |t|
      t.belongs_to :character, foreign_key: true
      t.belongs_to :proficiency, foreign_key: true
      t.string :proficiency_type

      t.timestamps
    end
  end
end
