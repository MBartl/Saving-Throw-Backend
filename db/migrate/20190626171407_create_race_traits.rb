class CreateRaceTraits < ActiveRecord::Migration[5.2]
  def change
    create_table :race_traits do |t|
      t.belongs_to :race, foreign_key: true
      t.belongs_to :trait, foreign_key: true

      t.timestamps
    end
  end
end
