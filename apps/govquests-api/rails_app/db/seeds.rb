require "securerandom"

def create_action(action_data)
  action_id = SecureRandom.uuid
  command = ActionTracking::CreateAction.new(
    action_id: action_id,
    action_type: action_data[:action_type],
    action_data: action_data[:action_data],
    display_data: action_data[:display_data]
  )
  Rails.configuration.command_bus.call(command)
  action_id
end

read_document = [
  {
    action_type: "read_document",
    display_data: {
      content: {
        title: "Code of conduct",
        description: ""
      }
    },
    action_data: {
      action_type: "read_document",
      document_url: "https://gov.optimism.io/t/code-of-conduct/5751"
    }
  },
  {
    action_type: "read_document",
    display_data: {
      content: {
        title: "Optimistic Vision",
        description: ""
      }
    },
    action_data: {
      action_type: "read_document",
      document_url: "https://www.optimism.io/vision"
    }
  },
  {
    action_type: "read_document",
    display_data: {
      content: {
        title: "Working Constitution",
        description: ""
      }
    },
    action_data: {
      action_type: "read_document",
      document_url: "https://gov.optimism.io/t/working-constitution-of-the-optimism-collective/55"
    }
  },
  {
    action_type: "read_document",
    display_data: {
      content: {
        title: "Delegate Expectations",
        description: ""
      }
    },
    action_data: {
      action_type: "read_document",
      document_url: "https://community.optimism.io/token-house/delegate-expectations"
    }
  }
]

gitcoin_action = {
  action_type: "gitcoin_score",
  display_data: {
    content: {
      title: "Complete Gitcoin Passport verification",
      description: "Let's be sure you're human!"
    }
  },
  action_data: {
    action_type: "gitcoin_score",
    min_score: 20
  }
}
actions_data = [
  *read_document,
  gitcoin_action
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
      intro: "As a Delegate, understanding Optimism's values and your responsibilities is key. This quest will provide essential resources to help you make informed decisions and contribute to Optimism’s future.",
      image_url: "https://example.com/governance101.jpg"
    },
    quest_type: "Onboarding",
    audience: "AllUsers",
    rewards: [{type: "Points", amount: 20}],
    actions: action_ids.first(4)
  },
  {
    display_data: {
      title: "Gitcoin Score",
      intro: "Connect your Gitcoin Passport and verify your Unique Humanity Score to help strengthen our community. It's quick and easy, and you'll be contributing to a more secure ecosystem!",
      image_url: "https://example.com/advanced-governance.jpg",
      requirements: 'Your Unique Humanity Score must be 20 or higher to complete this quest. Not there yet? Check some tips on how to increase your score.'
    },
    quest_type: "Governance",
    audience: "Delegates",
    rewards: [{type: "Points", amount: 100}],
    actions: [action_ids.last]
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
    puts "Associated action #{action_id} with quest #{quest_id} at position #{index + 1}"
  end

  puts "Created quest: #{quest_data[:display_data][:title]} (#{quest_id}) with #{quest_data[:actions].size} actions"
end

puts "Quests created and actions associated successfully!"
