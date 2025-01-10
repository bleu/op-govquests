class AddBadgeIdToTracksAndQuests < ActiveRecord::Migration[8.1]
  def change
    add_column :tracks, :badge_id, :string
    add_column :quests, :badge_id, :string
    add_index :tracks, :badge_id
    add_index :quests, :badge_id
  end
end
