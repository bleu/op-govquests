class CreateProposals < ActiveRecord::Migration[8.1]
  def change
    create_table :proposals do |t|
      t.string :proposal_id, null: false
      t.string :title
      t.string :description
      t.string :status
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end

    add_index :proposals, :proposal_id, unique: true
  end
end
