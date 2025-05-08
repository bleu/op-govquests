class AddEmailVerificationTokenToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :email_verification_token, :string
    add_column :users, :pending_email_verification, :boolean, default: false

    add_index :users, :email_verification_token, unique: true
  end
end
