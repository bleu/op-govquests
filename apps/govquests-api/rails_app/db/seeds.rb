require "securerandom"

module ActionCreation
  def self.create_action(action_data)
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
end

module QuestCreation
  def self.create_quest_with_rewards(quest_data)
    quest_id = SecureRandom.uuid

    Rails.configuration.command_bus.call(
      Questing::CreateQuest.new(
        quest_id: quest_id,
        display_data: quest_data[:display_data],
        audience: quest_data[:audience]
      )
    )

    quest_data[:rewards].each do |reward|
      pool_id = SecureRandom.uuid
      Rails.configuration.command_bus.call(
        Rewarding::CreateRewardPool.new(
          pool_id: pool_id,
          quest_id: quest_id,
          reward_definition: reward,
          initial_inventory: (reward["type"] == "Token") ? 1000 : nil
        )
      )

      Rails.configuration.command_bus.call(
        Questing::AssociateRewardPool.new(
          quest_id: quest_id,
          pool_id: pool_id,
          reward_definition: reward
        )
      )
    end

    quest_id
  end

  def self.associate_action_with_quest(quest_id, action_id, position)
    Rails.configuration.command_bus.call(
      Questing::AssociateActionWithQuest.new(
        quest_id: quest_id,
        action_id: action_id,
        position: position
      )
    )
  end
end

module QuestData
  DISCOURSE_VERIFICATION_ACTION = {
    action_type: "discourse_verification",
    display_data: {
      title: "Verify Discourse Account",
      description: "To verify you must authorize GovQuest's access to your Discourse Account. After your authorization, you'll be provided with the API Key that must be entered bellow."
    },
    action_data: {
      action_type: "discourse_verification",
      discourse_url: "https://gov.optimism.io"
    }
  }
  UNLOCK_PROFILE_ACTIONS = [
    {
      action_type: "send_email",
      display_data: {
        title: "Inform your e-mail (optional)",
        description: "Get notified about your achievements, new quests and more. We won't spam you :)"
      },
      action_data: {
        action_type: "send_email"
      }
    },
    {
      action_type: "wallet_verification",
      display_data: {
        title: "Connect your wallet",
        description: "Track your progress, earn rewards, and get recognized for your contributions."
      },
      action_data: {
        action_type: "wallet_verification"
      }
    }
  ]

  READ_DOCUMENT_ACTIONS = [
    {
      action_type: "read_document",
      display_data: {
        title: "Code of conduct",
        description: ""
      },
      action_data: {
        action_type: "read_document",
        document_url: "https://gov.optimism.io/t/code-of-conduct/5751"
      }
    },
    {
      action_type: "read_document",
      display_data: {
        title: "Optimistic Vision",
        description: ""
      },
      action_data: {
        action_type: "read_document",
        document_url: "https://www.optimism.io/vision"
      }
    },
    {
      action_type: "read_document",
      display_data: {
        title: "Working Constitution",
        description: ""
      },
      action_data: {
        action_type: "read_document",
        document_url: "https://gov.optimism.io/t/working-constitution-of-the-optimism-collective/55"
      }
    },
    {
      action_type: "read_document",
      display_data: {
        title: "Delegate Expectations",
        description: ""
      },
      action_data: {
        action_type: "read_document",
        document_url: "https://community.optimism.io/token-house/delegate-expectations"
      }
    }
  ]

  GITCOIN_ACTION = {
    action_type: "gitcoin_score",
    display_data: {
      title: "Connect your Gitcoin Passport",
      description: "Let's be sure you're human!"
    },
    action_data: {
      action_type: "gitcoin_score",
      min_score: 20
    }
  }

  ENS_ACTION = {
    action_type: "ens",
    display_data: {
      title: "Verify ENS",
      description: "Claim your unique ENS name!"
    },
    action_data: {
      action_type: "ens"
    }
  }

  VERIFY_POSITION_ACTION = {
    action_type: "verify_position",
    display_data: {
      title: "Verify your position",
      description: "Click to verify your status as a Top 100 Delegate."
    },
    action_data: {
      action_type: "verify_position",
      should_be_higher_than: 100
    }
  }

  VERIFY_DELEGATE_ACTION = {
    action_type: "verify_delegate",
    display_data: {
      title: "Become a Delegate",
      description: "<ul><li>Connect your wallet at <a href='https://vote.optimism.io/' target='_blank' rel='noopener noreferrer' >Agora</a> - the home of Optimism voters.</li><li>At Agora, to become a delegate, you must have OP tokens <strong>delegated to your address.</strong> </li><li>That means that someone has to delegate their tokens to you, or you can delegate your own tokens to yourself, by following Agora's instructions. </li><li>Once OP tokens delegates to your address, come back to GovQuest and claim your rewards!</li></ul>"
    },
    action_data: {
      action_type: "verify_delegate"
    }
  }

  VERIFY_DELEGATE_STATEMENT = {
    action_type: "verify_delegate_statement",
    display_data: {
      title: "Delegate Statement",
      description: "<ul><li>Connect your wallet at <a href='https://vote.optimism.io/' target='_blank' rel='noopener noreferrer'>Agora</a> - the home of Optimism voters.</li><li>Write and publish your delegate statement — keep in mind that your statement will be reviewed by Delegators who will decide whether to grant you voting power!</li><li><strong>Here's a suggested format for your delegate statement:</strong><ul><li>A brief introduction about your background in crypto and what makes you a valuable candidate.</li><li>Your thoughts on the <a href='https://www.optimism.io/vision' target='_blank' rel='noopener noreferrer'>Optimistic Vision</a>.</li><li>Insights on the first three articles of the <a href='https://gov.optimism.io/t/working-constitution-of-the-optimism-collective/55' target='_blank' rel='noopener noreferrer'>Working Constitution</a></li><li>Your interests, which can be either general or crypto-related.</li><li>Your favorite crypto projects.</li></ul></li><li><strong>Once your delegate statement is published, come back to GovQuests and verify!</strong></li></ul>"
    },
    action_data: {
      action_type: "verify_delegate_statement"
    }
  }
  VERIFY_DELEGATE_STATEMENT = {
    action_type: "verify_delegate_statement",
    display_data: {
      title: "Delegate Statement",
      description: "<ul><li>Connect your wallet at <a href='https://vote.optimism.io/' target='_blank' rel='noopener noreferrer'>Agora</a> - the home of Optimism voters.</li><li>Write and publish your delegate statement — keep in mind that your statement will be reviewed by Delegators who will decide whether to grant you voting power!</li><li><strong>Here's a suggested format for your delegate statement:</strong><ul><li>A brief introduction about your background in crypto and what makes you a valuable candidate.</li><li>Your thoughts on the <a href='https://www.optimism.io/vision' target='_blank' rel='noopener noreferrer'>Optimistic Vision</a>.</li><li>Insights on the first three articles of the <a href='https://gov.optimism.io/t/working-constitution-of-the-optimism-collective/55' target='_blank' rel='noopener noreferrer'>Working Constitution</a></li><li>Your interests, which can be either general or crypto-related.</li><li>Your favorite crypto projects.</li></ul></li><li><strong>Once your delegate statement is published, come back to GovQuests and verify!</strong></li></ul>"
    },
    action_data: {
      action_type: "verify_delegate_statement"
    }
  }

  VERIFY_AGORA = {
    action_type: "verify_agora",
    display_data: {
      title: "Connect to Agora",
      description: "Agora is the home of Optimism voters. You must connect before voting."
    },
    action_data: {
      action_type: "verify_agora"
    }
  }

  VERIFY_FIRST_VOTE = {
    action_type: "verify_first_vote",
    display_data: {
      title: "Cast your first vote",
      description: "<ul><li>Choose an <a href='https://vote.optimism.io/' target='_blank' rel='noopener noreferrer'>open proposal here</a> and <strong>cast your vote.</strong></li><li>Don't forget to <strong>share your reasoning</strong> to help the community understand your perspective.</li><li>Once you're done, <strong>come back to complete the quest and claim your reward.</strong></li></ul>"
    },
    action_data: {
      action_type: "verify_first_vote"
    }
  }

  QUESTS = [
    {
      display_data: {
        title: "Claim Your Identity",
        intro: "Building a strong reputation in the Optimism Collective starts with having a <strong>Ethereum Name Service (ENS)</strong>, and also a <strong>recognizable name</strong> in the Governance Forum. A unique identity helps the community remember you and <strong>connects your ideas to a trusted name.</strong> Let’s take the first step towards establishing your presence in OP governance!",
        image_url: "https://example.com/discourse-verification.jpg",
        requirements: "<span>To complete this quest, you need to have:</span> <ul><li>A <strong>ENS</strong> — if you don't have it, <a href='https://ens.domains/' target='_blank' rel='noopener noreferrer'>register your ENS here</a> and remember to <strong>choose a distinct username</strong> that represents you (like yourname.eth).</li> <li>A <strong>Discourse account</strong> on <strong>Optimism Governance Forum</strong> — if you also don't have it, <a href='https://gov.optimism.io/' target='_blank' rel='noopener noreferrer'>create your account here.</a> We recommend you to use your ENS as username so you can get easily recognizable.</li></ul>"
      },
      audience: "Delegates",
      rewards: [{type: "Points", amount: 165}],
      actions: [ENS_ACTION, DISCOURSE_VERIFICATION_ACTION]
    },
    {
      display_data: {
        title: "Unlock Your Profile",
        intro: "Connect your wallet to unlock the full experience. Track your progress, earn rewards, and get recognized for your contributions.",
        image_url: "https://example.com/governance101.jpg"
      },
      audience: "AllUsers",
      rewards: [{type: "Points", amount: 55}],
      actions: UNLOCK_PROFILE_ACTIONS
    },
    {
      display_data: {
        title: "Governance 101",
        intro: "As a Delegate, understanding Optimism's values and your responsibilities is key. This quest will provide essential resources to help you make informed decisions and contribute to Optimism's future.",
        image_url: "https://example.com/governance101.jpg"
      },
      audience: "AllUsers",
      rewards: [{type: "Points", amount: 165}],
      actions: READ_DOCUMENT_ACTIONS
    },
    {
      display_data: {
        title: "Gitcoin Score",
        intro: "Connect your Gitcoin Passport and verify your Unique Humanity Score to help strengthen our community. It's quick and easy, and you'll be contributing to a more secure ecosystem!",
        image_url: "https://example.com/advanced-governance.jpg",
        requirements: "Your Unique Humanity Score must be 20 or higher to complete this quest. Not there yet? Check some tips on how to increase your score."
      },
      audience: "Delegates",
      rewards: [{type: "Points", amount: 55}],
      actions: [GITCOIN_ACTION]
    },

    {
      display_data: {
        title: "Top 100 Delegates",
        intro: "Have you reached the Top 100 Delegates in Season 6? Let’s check your ranking and, if you’re among the top, celebrate your achievement with a reward!",
        image_url: "https://example.com/advanced-governance.jpg",
        requirements: "You need to be a delegate to do this quest! If you’re not one, start with Become Delegate Quest."
      },
      audience: "Delegates",
      rewards: [{type: "Points", amount: 165}],
      actions: [VERIFY_POSITION_ACTION]
    },
    {
      display_data: {
        title: "Become a delegate",
        intro: "Start your journey as a delegate in the Optimism community! This quest will guide you through the essential steps to become a representative within the ecosystem and share your ideas. Let’s get started!",
        image_url: "https://example.com/governance101.jpg",
        requirements: "This quest is for new delegates — those who become delegates after opening this content. If you're already a delegate, try referring new delegates to earn rewards!"
      },
      quest_type: "Governance",
      audience: "NonDelegates",
      rewards: [{type: "Points", amount: 20}],
      actions: [VERIFY_DELEGATE_ACTION]
    },
    {
      display_data: {
        title: "Delegate statement",
        intro: "Creating a delegate statement helps you communicate your values and priorities within the Optimism governance. It allows delegators to make informed decisions about whom to support.",
        image_url: "https://example.com/governance101.jpg",
        requirements: "This quest is for delegates who don't have their delegate statement yet. If you already have one, take a look in the other quests for delegates!"
      },
      quest_type: "Governance",
      audience: "Delegates",
      rewards: [{type: "Points", amount: 20}],
      actions: [VERIFY_DELEGATE_STATEMENT]
    },
    {
      display_data: {
        title: "First Vote Milestone",
        intro: "As a delegate, casting your first vote is an important step in shaping the future. Step up, participate, and make your mark with your first vote!",
        image_url: "https://example.com/governance101.jpg",
        requirements: "To complete this quest, you need to <strong>be a registered delegate</strong> — if you’re not, start with Become Delegate Quest — and <strong>not have cast a vote</strong> yet."
      },
      quest_type: "Governance",
      audience: "Delegates",
      rewards: [{type: "Points", amount: 20}],
      actions: [VERIFY_AGORA, VERIFY_FIRST_VOTE]
    }
  ]
end

def create_quests_and_actions
  puts "Creating quests, actions, and reward pools..."

  QuestData::QUESTS.each do |quest_data|
    # Create quest and its reward pools
    quest_id = QuestCreation.create_quest_with_rewards(quest_data)
    puts "Created quest: #{quest_data[:display_data][:title]} (#{quest_id})"
    puts "Created reward pools for quest rewards: #{quest_data[:rewards].inspect}"

    # Create and associate actions
    quest_data[:actions].each_with_index do |action_data, index|
      action_id = ActionCreation.create_action(action_data)
      QuestCreation.associate_action_with_quest(quest_id, action_id, index + 1)
      puts "Created and associated action: #{action_data[:display_data][:title]} (#{action_id}) with quest #{quest_id} at position #{index + 1}"
    end

    puts "Completed quest: #{quest_data[:display_data][:title]} (#{quest_id}) with #{quest_data[:actions].size} actions"
    puts "---"
  end

  puts "All quests created with their actions and reward pools successfully!"
end

create_quests_and_actions
