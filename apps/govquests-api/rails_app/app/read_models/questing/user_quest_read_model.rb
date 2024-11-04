module Questing
  class UserQuestReadModel < ApplicationRecord
    self.table_name = "user_quests"

    belongs_to :quest, class_name: "Questing::QuestReadModel", foreign_key: "quest_id", primary_key: "quest_id"
    belongs_to :user, class_name: "Authentication::UserReadModel", foreign_key: "user_id", primary_key: "user_id"
  end
end

# == Schema Information
#
# Table name: user_quests
#
#  id               :bigint           not null, primary key
#  completed_at     :datetime
#  progress_measure :integer          default(0)
#  started_at       :datetime
#  status           :string           default("started")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  quest_id         :string           not null
#  user_id          :string           not null
#  user_quest_id    :string           not null
#
# Indexes
#
#  index_user_quests_on_quest_id_and_user_id  (quest_id,user_id) UNIQUE
#  index_user_quests_on_user_quest_id         (user_quest_id) UNIQUE
#
