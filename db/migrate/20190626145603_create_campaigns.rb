class CreateCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.text :description
      t.text :pictures
      t.integer :max_players

      t.timestamps
    end
  end
end
