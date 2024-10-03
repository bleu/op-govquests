# rails_app/db/migrate/20240930201751_create_actions.rb
class CreateActions < ActiveRecord::Migration[8.0]
  def change
    create_table :actions do |t|
      t.string :action_id, null: false, index: { unique: true }
      t.string :content, null: false
      t.string :priority, null: false
      t.string :channel, null: false
      t.string :status, default: "Pending"
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
  end
end
