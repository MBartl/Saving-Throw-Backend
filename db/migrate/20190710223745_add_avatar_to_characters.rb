class AddAvatarToCharacters < ActiveRecord::Migration[5.2]
  def change
    add_column :characters, :avatar, :string
  end
end
