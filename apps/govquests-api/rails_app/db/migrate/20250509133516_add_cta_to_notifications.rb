class AddCtaToNotifications < ActiveRecord::Migration[8.1]
  def change
    add_column :notifications, :cta_text, :string
    add_column :notifications, :cta_url, :string
  end
end
