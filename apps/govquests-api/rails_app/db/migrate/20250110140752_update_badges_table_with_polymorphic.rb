class UpdateBadgesTableWithPolymorphic < ActiveRecord::Migration[8.1]
  def change
    remove_column :badges, :track_id if column_exists?(:badges, :track_id)
    remove_column :badges, :quest_id if column_exists?(:badges, :quest_id)

    add_column :badges, :badgeable_type, :string, null: false
    add_column :badges, :badgeable_id, :string, null: false

    add_index :badges, [:badgeable_type, :badgeable_id], unique: true
  end
end
