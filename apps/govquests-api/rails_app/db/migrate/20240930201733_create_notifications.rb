class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.string :notification_id, null: false, index: { unique: true }
      t.string :content, null: false
      t.string :priority, null: false
      t.string :channel, null: false
      t.string :template_id, null: true
      t.string :status, default: "Pending"
      t.datetime :scheduled_at, null: true
      t.timestamps
    end

    create_table :notification_templates do |t|
      t.string :template_id, null: false, index: { unique: true }
      t.string :name, null: false
      t.text :content, null: false
      t.string :content_type, null: false, default: "text/plain"
      t.timestamps
    end
  end
end
