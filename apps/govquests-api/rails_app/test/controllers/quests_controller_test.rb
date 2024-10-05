# test/controllers/quests_controller_test.rb
require "test_helper"

class QuestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quest = create(:quest_read_model)
    @action = create(:action_read_model)
    create(:quest_action_read_model, quest: @quest, action: @action)
  end

  test "should get index" do
    get quests_path
    assert_response :success
    quests = JSON.parse(response.body)
    assert_equal 1, quests.length
    assert_equal @quest.quest_id, quests.first["id"]
  end

  test "should get show" do
    get quest_path(@quest.quest_id)
    assert_response :success
    quest = JSON.parse(response.body)
    assert_equal @quest.quest_id, quest["id"]
    assert_equal 1, quest["actions"].length
    assert_equal @action.action_id, quest["actions"].first["id"]
  end

  test "should return not found for non-existent quest" do
    get quest_path("non_existent_id")
    assert_response :not_found
  end
end
