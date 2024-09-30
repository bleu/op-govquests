require "test_helper"

module Quests
  class CreateTest < InMemoryTestCase
    cover "Questing*"

    def setup
      super
      Quests::Quest.destroy_all
    end

    def test_set_create
      quest_id = SecureRandom.uuid


      run_command(
        Questing::RegisterQuest.new(
          quest_id: quest_id,
        )
      )

      account = Quests::Quest.find_by(quest_id: quest_id)
      assert account.present?
    end

    private

    def event_store
      Rails.configuration.event_store
    end
  end
end
