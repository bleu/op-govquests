class MakeBadgeableOptionalInBadges < ActiveRecord::Migration[8.1]
  def change
    change_column_null :badges, :badgeable_type, true
    change_column_null :badges, :badgeable_id, true

    remove_index :badges, [:badgeable_type, :badgeable_id]
    add_index :badges, [:badgeable_type, :badgeable_id],
      unique: true,
      where: "badgeable_type IS NOT NULL AND badgeable_id IS NOT NULL"
  end
end
