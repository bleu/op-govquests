class AddNotificationsPreferencesToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :telegram_notifications, :boolean, default: false
    add_column :users, :email_notifications, :boolean, default: false
  end
end
