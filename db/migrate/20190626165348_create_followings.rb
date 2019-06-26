class CreateFollowings < ActiveRecord::Migration[5.2]
  def change
    create_table :followings do |t|
      t.integer :follower_id, class_name: "User"
      t.integer :following_id, class_name: "User"

      t.timestamps
    end
  end
end
