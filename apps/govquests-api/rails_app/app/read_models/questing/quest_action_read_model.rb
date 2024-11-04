module Questing
  class QuestActionReadModel < ApplicationRecord
    self.table_name = "quest_actions"

    belongs_to :quest, class_name: "Questing::QuestReadModel", foreign_key: "quest_id", primary_key: "quest_id"
    belongs_to :action, class_name: "ActionTracking::ActionReadModel", foreign_key: "action_id", primary_key: "action_id"
  end
end

# == Schema Information
#
# Table name: quest_actions
#
#  id         :bigint           not null, primary key
#  position   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  action_id  :string           not null
#  quest_id   :string           not null
#
# Indexes
#
#  index_quest_actions_on_quest_id_and_action_id  (quest_id,action_id) UNIQUE
#  index_quest_actions_on_quest_id_and_position   (quest_id,position) UNIQUE
#
