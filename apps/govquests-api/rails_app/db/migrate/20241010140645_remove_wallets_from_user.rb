class RemoveWalletsFromUser < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      t.remove :wallets
      t.string :address, null: false
      t.integer :chain_id, null: false
    end
  end
end
