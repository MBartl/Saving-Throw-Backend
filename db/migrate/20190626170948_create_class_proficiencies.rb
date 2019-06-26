class CreateClassProficiencies < ActiveRecord::Migration[5.2]
  def change
    create_table :class_proficiencies do |t|
      t.belongs_to :player_class, foreign_key: true
      t.belongs_to :proficiency, foreign_key: true

      t.timestamps
    end
  end
end
