class RecreateTrackQuests < ActiveRecord::Migration[8.1]
  def change
    create_table :track_quests do |t|
      t.string :track_id, null: false
      t.string :quest_id, null: false
      t.integer :position, null: false

      t.timestamps
    end

    add_index :track_quests, [:track_id, :quest_id], unique: true
    add_index :track_quests, [:track_id, :position], unique: true
  end
end
