class AddEmailVerificationTokenToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :email_verification_token, :string
  end
end
