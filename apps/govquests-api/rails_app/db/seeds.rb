require "securerandom"

def create_action(action_data)
  action_id = SecureRandom.uuid
  command = ActionTracking::CreateAction.new(
    action_id: action_id,
    content: action_data[:content],
    action_type: action_data[:action_type],
    completion_criteria: action_data[:completion_criteria]
  )
  Rails.configuration.command_bus.call(command)
  action_id
end

actions_data = [
  {
    content: "Read the Code of Conduct",
    action_type: "ReadDocument",
    completion_criteria: {document_url: "https://example.com/code-of-conduct"}
  },
  {
    content: "Watch the Optimistic Vision video",
    action_type: "WatchVideo",
    completion_criteria: {video_url: "https://example.com/optimistic-vision", minimum_watch_time: 540}
  },
  {
    content: "Complete the Constitution Quiz",
    action_type: "Quiz",
    completion_criteria: {quiz_id: "const101", passing_score: 80}
  },
  {
    content: "Submit your Delegate Statement",
    action_type: "TextSubmission",
    completion_criteria: {min_words: 200, max_words: 500}
  },
  {
    content: "Participate in a Mock Proposal Vote",
    action_type: "VotingSimulation",
    completion_criteria: {proposal_id: "mock001", options: ["Yes", "No", "Abstain"]}
  },
  {
    content: "Analyze Governance Analytics Dashboard",
    action_type: "DashboardInteraction",
    completion_criteria: {dashboard_id: "gov_analytics_01", min_interaction_time: 1200}
  }
]

puts "Creating actions..."
actions_data.each do |action_data|
  action_id = create_action(action_data)
  # rails_app/db/seeds/actions.rb (continued)
  puts "Created action: #{action_data[:content]} (#{action_id})"
end

puts "Actions created successfully!"

quests_data = [
  {
    title: "Governance 101",
    intro: "Understand the Optimism Values and your role in governance.",
    quest_type: "Onboarding",
    audience: "AllUsers",
    reward: {type: "Points", amount: 50},
    actions: [
      "Read the Code of Conduct",
      "Watch the Optimistic Vision video",
      "Complete the Constitution Quiz",
      "Submit your Delegate Statement"
    ]
  },
  {
    title: "Advanced Governance Practices",
    intro: "Dive deeper into governance processes and decision-making.",
    quest_type: "Governance",
    audience: "Delegates",
    reward: {type: "Points", amount: 100},
    actions: [
      "Participate in a Mock Proposal Vote",
      "Analyze Governance Analytics Dashboard",
      "Submit your Delegate Statement",
      "Complete the Constitution Quiz"
    ]
  }
]

def create_quest(quest_data)
  quest_id = SecureRandom.uuid
  command = Questing::CreateQuest.new(
    quest_id: quest_id,
    title: quest_data[:title],
    intro: quest_data[:intro],
    quest_type: quest_data[:quest_type],
    audience: quest_data[:audience],
    reward: quest_data[:reward]
  )
  Rails.configuration.command_bus.call(command)
  quest_id
end

def associate_action_with_quest(quest_id, action_id, position)
  command = Questing::AssociateActionWithQuest.new(
    quest_id: quest_id,
    action_id: action_id,
    position: position
  )
  Rails.configuration.command_bus.call(command)
end

puts "Creating quests and associating actions..."
quests_data.each do |quest_data|
  quest_id = create_quest(quest_data)

  # Wait for the quest to be created in the read model
  retries = 0
  until Questing::QuestReadModel.exists?(quest_id: quest_id)
    sleep(0.5)
    retries += 1
    if retries > 10
      puts "Failed to create quest in read model after 5 seconds: #{quest_data[:title]}"
      break
    end
  end

  quest_data[:actions].each_with_index do |action_content, index|
    action = ActionTracking::ActionReadModel.find_by("display_data @> ?", {content: action_content}.to_json)
    if action
      associate_action_with_quest(quest_id, action.action_id, index + 1)
    else
      puts "Warning: Action '#{action_content}' not found"
    end
  end

  puts "Created quest: #{quest_data[:title]} (#{quest_id}) with #{quest_data[:actions].size} actions"
end

puts "Quests created and actions associated successfully!"
