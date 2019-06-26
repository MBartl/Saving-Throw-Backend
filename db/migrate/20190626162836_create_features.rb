class CreateFeatures < ActiveRecord::Migration[5.2]
  def change
    create_table :features do |t|
      t.string :name
      t.belongs_to :player_class, foreign_key: true
      t.integer :level
      t.text :desc

      t.timestamps
    end
  end
end
