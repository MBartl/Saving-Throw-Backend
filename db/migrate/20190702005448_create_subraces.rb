class CreateSubraces < ActiveRecord::Migration[5.2]
  def change
    create_table :subraces do |t|
      t.string :name
      t.belongs_to :race, foreign_key: true
      t.text :desc
      t.string :ability_bonuses

      t.timestamps
    end
  end
end
