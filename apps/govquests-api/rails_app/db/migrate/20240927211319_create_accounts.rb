class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :account_id
      t.string :string
      t.string :address
      t.integer :chain_id

      t.timestamps
    end
  end
end
