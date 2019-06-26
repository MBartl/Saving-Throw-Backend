class CreateSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :skills do |t|
      t.belongs_to :character, foreign_key: true
      t.integer :athletics
      t.integer :acrobatics
      t.integer :sleight_of_hand
      t.integer :stealth
      t.integer :arcana
      t.integer :history
      t.integer :investigation
      t.integer :nature
      t.integer :religion
      t.integer :animal_handling
      t.integer :insight
      t.integer :medicine
      t.integer :perception
      t.integer :survival
      t.integer :deception
      t.integer :intimidation
      t.integer :performance
      t.integer :persuasion

      t.timestamps
    end
  end
end
