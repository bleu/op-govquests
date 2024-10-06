class CreateUserQuests < ActiveRecord::Migration[8.0]
  def change
    create_table :user_quests do |t|
      t.string :quest_id, null: false
      t.string :user_id, null: false
      t.string :status, default: "started"
      t.integer :progress_measure, default: 0
      t.datetime :started_at, null: true
      t.datetime :completed_at, null: true
      t.timestamps
    end

    add_index :user_quests, %i[quest_id user_id], unique: true
  end
end
