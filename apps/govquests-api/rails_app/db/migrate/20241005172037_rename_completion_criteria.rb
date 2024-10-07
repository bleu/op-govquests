class RenameCompletionCriteria < ActiveRecord::Migration[8.0]
  def change
    change_table :actions do |t|
      t.rename :completion_criteria, :action_data
    end
  end
end
