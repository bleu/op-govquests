FactoryBot.define do
  factory :user, class: "Authentication::UserReadModel" do
    user_id { SecureRandom.uuid }
    email { Faker::Internet.email }
    user_type { "non_delegate" }
  end

  factory :quest_read_model, class: "Questing::QuestReadModel" do
    quest_id { SecureRandom.uuid }
    quest_type { "Standard" }
    audience { "AllUsers" }
    status { "created" }
    rewards { [{type: "Points", amount: 50}] }
    display_data { {title: "Test Quest", intro: "Test Intro"} }
  end

  factory :action_read_model, class: "ActionTracking::ActionReadModel" do
    action_id { SecureRandom.uuid }
    action_type { "read_document" }
    action_data { {foo: "bar"} }
    display_data { {content: "Test Action"} }
  end

  factory :action_execution_read_model, class: "ActionTracking::ActionExecutionReadModel" do
    execution_id { SecureRandom.uuid }
    action_id { create(:action_read_model).action_id }
    user_id { SecureRandom.uuid }
    action_type { "test_action" }
    started_at { Time.current }
    status { "started" }
  end

  factory :quest_action_read_model, class: "Questing::QuestActionReadModel" do
    association :quest, factory: :quest_read_model
    association :action, factory: :action_read_model
    position { 1 }
  end
end
