class AddDisplayDataToActions < ActiveRecord::Migration[8.0]
  def change
    change_table :actions do |t|
      t.jsonb :display_data, default: {}
    end
  end
end
