class AddAdminRoleToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :is_admin, :boolean
  end
end
