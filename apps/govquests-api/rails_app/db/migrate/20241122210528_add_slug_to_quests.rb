class AddSlugToQuests < ActiveRecord::Migration[8.1]
  def change
    add_column :quests, :slug, :string
  end
end
