class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.string :notification_id, null: false, index: {unique: true}
      t.string :content, null: false
      t.integer :priority, null: false
      t.string :template_id, null: false
      t.string :user_id, null: false
      t.string :channel, null: false
      t.string :status, default: "created"
      t.string :notification_type, null: false
      t.datetime :scheduled_time
      t.datetime :sent_at
      t.datetime :received_at
      t.datetime :opened_at
      t.timestamps
    end

    create_table :notification_templates do |t|
      t.string :template_id, null: false, index: {unique: true}
      t.string :name, null: false, index: {unique: true}
      t.text :content, null: false
      t.string :template_type, null: false
      t.timestamps
    end

    add_index :notifications, :template_id
    add_index :notifications, :user_id
    add_index :notifications, :channel
  end
end
