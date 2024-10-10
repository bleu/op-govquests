class RemoveEmailRequirementFromUsers < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      t.change :email, :string, null: true
    end
  end
end
