class CreateTracks < ActiveRecord::Migration[8.1]
  def change
    create_table :tracks do |t|
      t.string :track_id, null: false, index: {unique: true}
      t.text :quest_ids
      # t.string :badge_id
      t.jsonb :display_data, null: false, default: {}

      t.timestamps
    end
  end
end
