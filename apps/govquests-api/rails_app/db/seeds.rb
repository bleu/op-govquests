require "securerandom"

def create_action(action_data)
  action_id = SecureRandom.uuid
  command = ActionTracking::CreateAction.new(
    action_id: action_id,
    action_type: action_data[:action_type],
    action_data: action_data[:action_data]
  )
  Rails.configuration.command_bus.call(command)
  action_id
end

actions_data = [
  {
    action_type: "ReadDocument",
    action_data: {
      content: "Read the Code of Conduct",
      document_url: "https://example.com/code-of-conduct"
    }
  },
  {
    action_type: "WatchVideo",
    action_data: {
      content: "Watch the Optimistic Vision video",
      video_url: "https://example.com/optimistic-vision",
      minimum_watch_time: 540
    }
  },
  {
    action_type: "Quiz",
    action_data: {
      content: "Complete the Constitution Quiz",
      quiz_id: "const101",
      passing_score: 80
    }
  },
  {
    action_type: "TextSubmission",
    action_data: {
      content: "Submit your Delegate Statement",
      min_words: 200,
      max_words: 500
    }
  },
  {
    action_type: "VotingSimulation",
    action_data: {
      content: "Participate in a Mock Proposal Vote",
      proposal_id: "mock001",
      options: ["Yes", "No", "Abstain"]
    }
  },
  {
    action_type: "DashboardInteraction",
    action_data: {
      content: "Analyze Governance Analytics Dashboard",
      dashboard_id: "gov_analytics_01",
      min_interaction_time: 1200
    }
  },
  {
    action_type: "gitcoin_score",
    action_data: {
      content: "Complete Gitcoin Passport verification",
      min_score: 20
    }
  },
  {
    action_type: "proposal_vote",
    action_data: {
      content: "Vote on Governance Proposal XYZ",
      proposal_id: "proposal_xyz"
    }
  }
]

puts "Creating actions..."
action_ids = actions_data.map do |action_data|
  action_id = create_action(action_data)
  puts "Created action: #{action_data[:action_data][:content]} (#{action_id})"
  action_id
end

puts "Actions created successfully!"

quests_data = [
  {
    display_data: {
      title: "Governance 101",
      intro: "Understand the Optimism Values and your role in governance.",
      image_url: "https://example.com/governance101.jpg"
    },
    quest_type: "Onboarding",
    audience: "AllUsers",
    rewards: [{type: "Points", amount: 50}],
    actions: action_ids.take(4) # Use the first 4 actions
  },
  {
    display_data: {
      title: "Advanced Governance Practices",
      intro: "Dive deeper into governance processes and decision-making.",
      image_url: "https://example.com/advanced-governance.jpg"
    },
    quest_type: "Governance",
    audience: "Delegates",
    rewards: [{type: "Points", amount: 100}],
    actions: action_ids.drop(4) # Use the last 4 actions
  }
]

def create_quest(quest_data)
  quest_id = SecureRandom.uuid
  command = Questing::CreateQuest.new(
    quest_id: quest_id,
    display_data: quest_data[:display_data],
    quest_type: quest_data[:quest_type],
    audience: quest_data[:audience],
    rewards: quest_data[:rewards]
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

  quest_data[:actions].each_with_index do |action_id, index|
    associate_action_with_quest(quest_id, action_id, index + 1)
  end

  puts "Created quest: #{quest_data[:display_data][:title]} (#{quest_id}) with #{quest_data[:actions].size} actions"
end

puts "Quests created and actions associated successfully!"
