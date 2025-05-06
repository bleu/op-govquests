class AddDelegateeToGameProfile < ActiveRecord::Migration[8.1]
  def change
    add_column :user_game_profiles, :delegatee, :string
  end
end
