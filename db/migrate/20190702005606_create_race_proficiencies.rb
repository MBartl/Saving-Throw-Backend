class CreateRaceProficiencies < ActiveRecord::Migration[5.2]
  def change
    create_table :race_proficiencies do |t|
      t.belongs_to :race, foreign_key: true
      t.belongs_to :subrace, foreign_key: true
      t.belongs_to :proficiency, foreign_key: true

      t.timestamps
    end
  end
end
