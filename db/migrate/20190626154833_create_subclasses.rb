class CreateSubclasses < ActiveRecord::Migration[5.2]
  def change
    create_table :subclasses do |t|
      t.string :name
      t.belongs_to :player_class, foreign_key: true
      t.string :flavor
      t.text :desc

      t.timestamps
    end
  end
end
