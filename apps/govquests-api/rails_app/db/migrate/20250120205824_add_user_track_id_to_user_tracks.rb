class AddUserTrackIdToUserTracks < ActiveRecord::Migration[8.1]
  def change
    add_column :user_tracks, :user_track_id, :string

    add_index :user_tracks, :user_track_id, unique: true
  end
end
