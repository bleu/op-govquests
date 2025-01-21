class AddTrackIdToQuests < ActiveRecord::Migration[8.1]
  def change
    add_column :quests, :track_id, :string

    add_index :quests, :track_id
  end
end
