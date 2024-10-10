class AddNonceToActionExecutions < ActiveRecord::Migration[8.0]
  def change
    change_table :action_executions do |t|
      t.string :nonce, null: false
    end
  end
end
