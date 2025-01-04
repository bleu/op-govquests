class SimplifyTracks < ActiveRecord::Migration[8.1]
  def change
    drop_table :track_quests

    add_column :tracks, :quest_ids, :jsonb, array: true, default: []
  end
end
