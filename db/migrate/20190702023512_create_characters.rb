class CreateCharacters < ActiveRecord::Migration[5.2]
  def change
    create_table :characters do |t|
      t.belongs_to :user, foreign_key: true
      t.string :name
      t.integer :level
      t.integer :hit_points
      t.integer :hp_levels
      t.text :bio
      t.belongs_to :player_class, foreign_key: true
      t.belongs_to :subclass, foreign_key: true
      t.belongs_to :race, foreign_key: true
      t.belongs_to :subrace, foreign_key: true

      t.timestamps
    end
  end
end
