# rails_app/db/migrate/20240930201751_create_actions.rb
class CreateActions < ActiveRecord::Migration[8.0]
  def change
    create_table :actions do |t|
      t.string :action_id, null: false, index: { unique: true }
      t.string :content, null: false
      t.string :action_type, null: false
      t.jsonb :completion_criteria, null: false, default: {}
      t.timestamps
    end

    create_table :action_logs do |t|
      t.string :action_log_id, null: false, index: { unique: true }
      t.string :action_id, null: false
      t.string :user_id, null: false
      t.datetime :executed_at, null: false
      t.string :status, null: false
      t.timestamps
    end

    create_table :quest_actions do |t|
      t.string :quest_id, null: false
      t.string :action_id, null: false
      t.integer :position, null: false
      t.timestamps
    end

    add_index :quest_actions, [ :quest_id, :action_id ], unique: true
    add_index :quest_actions, [ :quest_id, :position ], unique: true
  end
end
