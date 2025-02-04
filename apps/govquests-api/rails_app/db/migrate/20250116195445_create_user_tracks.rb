class CreateUserTracks < ActiveRecord::Migration[8.1]
  def change
    create_table :user_tracks do |t|
      t.string :track_id, null: false
      t.string :user_id, null: false
      t.string :status, null: false, default: 'in_progress'
      t.datetime :completed_at
      t.timestamps
    end

    add_index :user_tracks, [:user_id, :track_id], unique: true
    add_index :user_tracks, :track_id
    add_index :user_tracks, :status
  end
end
