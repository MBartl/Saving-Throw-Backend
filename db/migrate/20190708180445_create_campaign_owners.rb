class CreateCampaignOwners < ActiveRecord::Migration[5.2]
  def change
    create_table :campaign_owners do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :campaign, foreign_key: true

      t.timestamps
    end
  end
end
