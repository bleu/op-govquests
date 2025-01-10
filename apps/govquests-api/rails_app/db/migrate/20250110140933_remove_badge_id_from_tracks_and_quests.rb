class RemoveBadgeIdFromTracksAndQuests < ActiveRecord::Migration[8.1]
  def change
    remove_index :tracks, :badge_id
    remove_index :quests, :badge_id

    remove_column :tracks, :badge_id
    remove_column :quests, :badge_id
  end
end
