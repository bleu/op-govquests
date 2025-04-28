module ActionCreation
  ACTION_CREATION_NAMESPACE_UUID = "eccead2c-ac0b-45ae-9e0b-9c6847fbf47f"

  def self.create_action(action_data)
    unique_name = "#{action_data[:display_data][:title]}-#{action_data[:action_type]}"
    action_id = Digest::UUID.uuid_v5(ACTION_CREATION_NAMESPACE_UUID, unique_name)

    begin
      command = ActionTracking::CreateAction.new(
        action_id: action_id,
        action_type: action_data[:action_type],
        action_data: action_data[:action_data],
        display_data: action_data[:display_data]
      )
      Rails.configuration.command_bus.call(command)
    rescue ActionTracking::Action::AlreadyCreatedError
      Rails.configuration.command_bus.call(
        ActionTracking::UpdateAction.new(
          action_id: action_id,
          action_data: action_data[:action_data],
          display_data: action_data[:display_data]
        )
      )
    end
    action_id
  end
end

module RewardPoolCreation
  POOL_CREATION_NAMESPACE_UUID = "85b7f3c9-a3bc-4c16-bb5d-2c0bed8a6da7"

  def self.create_pool(rewardable_id, rewardable_type, reward)
    pool_unique_name = "#{rewardable_type}$#{rewardable_id}-#{reward[:type]}"
    pool_id = Digest::UUID.uuid_v5(POOL_CREATION_NAMESPACE_UUID, pool_unique_name)

    reward.delete("inventory")

    begin
      Rails.configuration.command_bus.call(
        Rewarding::CreateRewardPool.new(
          pool_id: pool_id,
          rewardable_id: rewardable_id,
          rewardable_type: rewardable_type,
          reward_definition: reward,
          initial_inventory: (reward[:type] == "Token") ? reward[:inventory] : nil
        )
      )
    rescue Rewarding::RewardPool::AlreadyCreated
      Rails.configuration.command_bus.call(
        Rewarding::UpdateRewardPool.new(
          pool_id: pool_id,
          reward_definition: reward
        )
      )
    end

    pool_id
  end
end

module QuestCreation
  QUEST_CREATION_NAMESPACE_UUID = "da70de27-5711-441c-a0a2-9832171492e3"

  def self.create_quest_with_rewards(quest_data)
    unique_name = quest_data[:display_data][:title]
    quest_id = Digest::UUID.uuid_v5(QUEST_CREATION_NAMESPACE_UUID, unique_name)

    begin
      Rails.configuration.command_bus.call(
        Questing::CreateQuest.new(
          quest_id: quest_id,
          display_data: quest_data[:display_data],
          audience: quest_data[:audience]
        )
      )
    rescue Questing::Quest::AlreadyCreatedError
      Rails.configuration.command_bus.call(
        Questing::UpdateQuest.new(
          quest_id: quest_id,
          display_data: quest_data[:display_data],
          audience: quest_data[:audience]
        )
      )
    end

    quest_data[:rewards].each do |reward|
      pool_id = RewardPoolCreation.create_pool(quest_id, "Questing::QuestReadModel", reward)

      begin
        Rails.configuration.command_bus.call(
          Questing::AssociateRewardPool.new(
            quest_id: quest_id,
            pool_id: pool_id,
            reward_definition: reward
          )
        )
      rescue Questing::Quest::RewardPoolAlreadyAssociatedError
        # Silently ignore
        puts "Reward pool already associated: #{pool_id}"
      end
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

module TrackCreation
  TRACK_CREATION_NAMESPACE_UUID = "86e60d5e-767b-4dcc-b7d3-5048e1db5b04"

  def self.create_track_with_quests(track_data, quest_id_map)
    track_id = Digest::UUID.uuid_v5(TRACK_CREATION_NAMESPACE_UUID, track_data[:display_data][:title])

    begin
      Rails.configuration.command_bus.call(
        Questing::CreateTrack.new(
          track_id: track_id,
          display_data: track_data[:display_data]
        )
      )
    rescue Questing::Track::AlreadyExists
      Rails.configuration.command_bus.call(
        Questing::UpdateTrack.new(
          track_id: track_id,
          display_data: track_data[:display_data]
        )
      )
    end

    track_data[:quests].each_with_index do |quest_title, index|
      quest_id = quest_id_map[quest_title]
      begin
        Rails.configuration.command_bus.call(
          Questing::AssociateQuestWithTrack.new(
            track_id: track_id,
            quest_id: quest_id,
            position: index + 1
          )
        )
      rescue Questing::Track::QuestAlreadyAssociated
        # Silently ignore
      end
    end

    track_id
  end
end

module BadgeCreation
  BADGE_CREATION_NAMESPACE_UUID = "04afddb4-b215-4862-a2e6-2222058e45de"

  def self.create_badge(badge_data, badgeable_id, badgeable_type)
    unique_name = "#{badgeable_type}$#{badgeable_id}"
    badge_id = Digest::UUID.uuid_v5(BADGE_CREATION_NAMESPACE_UUID, unique_name)

    begin
      Rails.configuration.command_bus.call(
        Gamification::CreateBadge.new(
          badge_id: badge_id,
          display_data: badge_data,
          badgeable_id: badgeable_id,
          badgeable_type: badgeable_type
        )
      )
    rescue Gamification::Badge::AlreadyCreated
      Rails.configuration.command_bus.call(
        Gamification::UpdateBadge.new(
          badge_id: badge_id,
          display_data: badge_data
        )
      )
    end

    badge_id
  end
end

module SpecialBadgeCreation
  SPECIALBADGE_CREATION_NAMESPACE_UUID = "101cb511-2dbd-4920-938a-13a56d07a0b8"

  def self.create_special_badge_with_rewards(badge_data)
    unique_name = "#{badge_data[:display_data][:title]}-#{badge_data[:badge_type]}"
    badge_id = Digest::UUID.uuid_v5(SPECIALBADGE_CREATION_NAMESPACE_UUID, unique_name)

    begin
      Rails.configuration.command_bus.call(
        Gamification::CreateSpecialBadge.new(
          badge_id: badge_id,
          display_data: badge_data[:display_data],
          badge_type: badge_data[:badge_type],
          badge_data: badge_data[:badge_data],
          points: badge_data[:points]
        )
      )
    rescue Gamification::SpecialBadge::AlreadyCreated
      Rails.configuration.command_bus.call(
        Gamification::UpdateSpecialBadge.new(
          badge_id: badge_id,
          display_data: badge_data[:display_data],
          badge_data: badge_data[:badge_data]
        )
      )
    end

    badge_data[:rewards].each do |reward|
      pool_id = RewardPoolCreation.create_pool(badge_id, "Gamification::SpecialBadgeReadModel", reward)

      begin
        Rails.configuration.command_bus.call(
          Gamification::AssociateRewardPool.new(
            badge_id: badge_id,
            pool_id: pool_id,
            reward_definition: reward
          )
        )
      rescue Gamification::SpecialBadge::RewardPoolAlreadyAssociatedError
        # Silently ignore
        puts "Reward pool already associated: #{pool_id}"
      end
    end

    badge_id
  end
end

module TierCreation
  TIER_CREATION_NAMESPACE_UUID = "9b130c84-5bb0-4b13-9cba-a96428fe2783"

  def self.create_tiers(tier_data)
    unique_name = tier_data[:display_data][:title]
    tier_id = Digest::UUID.uuid_v5(TIER_CREATION_NAMESPACE_UUID, unique_name)

    begin
      Rails.configuration.command_bus.call(
        Gamification::CreateTier.new(
          tier_id:,
          display_data: tier_data[:display_data],
          multiplier: tier_data[:multiplier],
          image_url: tier_data[:image_url],
          min_delegation: tier_data[:min_delegation],
          max_delegation: tier_data[:max_delegation]
        )
      )
    rescue Gamification::Tier::AlreadyCreated
      Rails.configuration.command_bus.call(
        Gamification::UpdateTier.new(
          tier_id:,
          display_data: tier_data[:display_data],
          multiplier: tier_data[:multiplier],
          image_url: tier_data[:image_url],
          min_delegation: tier_data[:min_delegation],
          max_delegation: tier_data[:max_delegation]
        )
      )
    end
  end
end

module TierData
  TIERS = [
    {
      display_data: {
        title: "Optimistic Supporter",
        description: "This tier is for not delegates. To advance to the next tier, become a delegate and start building your governance influence!"
      },
      multiplier: 1.0,
      image_url: "/backgrounds/OP_BLEU_TIER_01.png",
      min_delegation: 0,
      max_delegation: 0
    },
    {
      display_data: {
        title: "Delegation Initiate",
        description: "This tier is for new delegates with up to 5K OP delegated. To advance to the next tier, work towards 30K OP delegated to you!"
      },
      multiplier: 1.0,
      image_url: "/backgrounds/OP_BLEU_TIER_02.png",
      min_delegation: 0,
      max_delegation: 5000
    },
    {
      display_data: {
        title: "Emerging Leader",
        description: "This tier is for delegates with 5K-30K OP delegated. To advance to the next tier, work towards 150K OP delegated to you! What waits you there: 1.5x multiplier."
      },
      multiplier: 1.5,
      image_url: "/backgrounds/OP_BLEU_TIER_03.png",
      min_delegation: 5000,
      max_delegation: 30000
    },
    {
      display_data: {
        title: "Strategic Delegate",
        description: "This tier is for delegates with 30K-150K OP delegated. To advance to the next tier, work towards over 150K OP delegated to you! What waits you there: 2x multiplier."
      },
      multiplier: 2.0,
      image_url: "/backgrounds/OP_BLEU_TIER_04.png",
      min_delegation: 30000,
      max_delegation: 150000
    },
    {
      display_data: {
        title: "Ecosystem Guardian",
        description: "This tier is for top delegates with 150K+ OP delegated. You've reached the pinnacle of governance participation! Keep maintaining your influence and inspiring the community."
      },
      multiplier: 2.5,
      image_url: "/backgrounds/OP_BLEU_TIER_05.png",
      min_delegation: 150000,
      max_delegation: nil
    }
  ]
end

module SpecialBadgeData
  SPECIAL_BADGES = [
    {
      display_data: {
        title: "Certified New Delegate",
        description: "Master the basics of delegation and voting. Complete the new delegate quest, submit your delegate statement, and cast your first vote!",
        image_url: "/badges/SPECIAL BADGE_01_02.png"
      },
      badge_type: "quests_completed",
      badge_data: {
        badge_type: "quests_completed",
        quests: ["Become a Delegate", "Delegate Statement", "First Vote Milestone"]
      },
      rewards: [
        {
          type: "Points",
          amount: 1000
        },
        {
          type: "Token",
          amount: 20
        }
      ]
    },
    {
      display_data: {
        title: "Apprentice Voter",
        description: "Cast your first 5 votes and start shaping the ecosystem!",
        image_url: "/badges/SPECIAL BADGE_03_02.png"
      },
      badge_type: "voter_achievement",
      badge_data: {
        badge_type: "voter_achievement",
        required_votes: 5
      },
      rewards: [
        {
          type: "Points",
          amount: 330
        }
      ]
    },
    {
      display_data: {
        title: "Active Voter",
        description: "Cast 10 votes and showcase your dedication to governance!",
        image_url: "/badges/SPECIAL BADGE_03_02.png"
      },
      badge_type: "voter_achievement",
      badge_data: {
        badge_type: "voter_achievement",
        required_votes: 10
      },
      rewards: [
        {
          type: "Points",
          amount: 330
        }
      ]
    },
    {
      display_data: {
        title: "Engaged Voter",
        description: "Cast 20 votes and prove your strong commitment to the community!",
        image_url: "/badges/SPECIAL BADGE_03_02.png"
      },
      badge_type: "voter_achievement",
      badge_data: {
        badge_type: "voter_achievement",
        required_votes: 20
      },
      rewards: [
        {
          type: "Points",
          amount: 330
        }
      ]
    },
    {
      display_data: {
        title: "Master Voter",
        description: "Cast 50 votes and establish yourself as a governance master!",
        image_url: "/badges/SPECIAL BADGE_03_02.png"
      },
      badge_type: "voter_achievement",
      badge_data: {
        badge_type: "voter_achievement",
        required_votes: 50
      },
      rewards: [
        {
          type: "Points",
          amount: 330
        }
      ]
    },
    {
      display_data: {
        title: "From Zero to Hero",
        description: "Empower new voices by delegating to someone with less than 1 OP. <a href='https://dune.com/optimismfnd/optimism-op-token-house' target='_blank' rel='noopener noreferrer'>Check them here</a>. Click on # OP Delegated to sort the column from the smallest to the largest value.",
        image_url: "/badges/SPECIAL BADGE_02_02.png"
      },
      badge_type: "delegation_empowerment",
      badge_data: {
        badge_type: "delegation_empowerment"
      },
      rewards: [
        {
          type: "Points",
          amount: 330
        }
      ]
    },
    {
      display_data: {
        title: "Season 7 Champion - Optimistic Supporter",
        description: "Claim your spot as the top performer in the Optimistic Supporter by being at the top of the Optimistic Supporter leaderboard by the end of the season (June 11th, 2025)!",
        image_url: "/badges/SPECIAL BADGE_06_02.png"
      },
      badge_type: "season_champion",
      badge_data: {
        badge_type: "season_champion",
        end_date: "2025-06-11",
        tier: "Optimistic Supporter"
      },
      rewards: [
        {
          type: "Points",
          amount: 1000
        },
        {
          type: "Token",
          amount: 30
        }
      ]
    },
    {
      display_data: {
        title: "Season 7 Champion - Delegation Initiate",
        description: "Claim your spot as the top performer in the Delegation Initiate by being at the top of the Delegation Initiate leaderboard by the end of the season (June 11th, 2025)!",
        image_url: "/badges/SPECIAL BADGE_06_02.png"
      },
      badge_type: "season_champion",
      badge_data: {
        badge_type: "season_champion",
        end_date: "2025-06-11",
        tier: "Delegation Initiate"
      },
      rewards: [
        {
          type: "Points",
          amount: 1000
        },
        {
          type: "Token",
          amount: 30
        }
      ]
    },
    {
      display_data: {
        title: "Season 7 Champion - Emerging Leader",
        description: "Claim your spot as the top performer in the Emerging Leader by being at the top of the Emerging Leader leaderboard by the end of the season (June 11th, 2025)!",
        image_url: "/badges/SPECIAL BADGE_06_02.png"
      },
      badge_type: "season_champion",
      badge_data: {
        badge_type: "season_champion",
        end_date: "2025-06-11",
        tier: "Emerging Leader"
      },
      rewards: [
        {
          type: "Points",
          amount: 1000
        },
        {
          type: "Token",
          amount: 20
        }

      ]
    },
    {
      display_data: {
        title: "Season 7 Champion - Strategic Delegate",
        description: "Claim your spot as the top performer in the Strategic Delegate by being at the top of the Strategic Delegate leaderboard by the end of the season (June 11th, 2025)!",
        image_url: "/badges/SPECIAL BADGE_06_02.png"
      },
      badge_type: "season_champion",
      badge_data: {
        badge_type: "season_champion",
        end_date: "2025-06-11",
        tier: "Strategic Delegate"
      },
      rewards: [
        {
          type: "Points",
          amount: 1000
        },
        {
          type: "Token",
          amount: 20
        }
      ]
    },
    {
      display_data: {
        title: "Season 7 Champion - Ecosystem Guardian",
        description: "Claim your spot as the top performer in the Ecosystem Guardian by being at the top of the Ecosystem Guardian leaderboard by the end of the season (June 11th, 2025)!",
        image_url: "/badges/SPECIAL BADGE_06_02.png"
      },
      badge_type: "season_champion",
      badge_data: {
        badge_type: "season_champion",
        end_date: "2025-06-11",
        tier: "Ecosystem Guardian"
      },
      rewards: [
        {
          type: "Points",
          amount: 1000
        },
        {
          type: "Token",
          amount: 15
        }
      ]
    },
    {
      display_data: {
        title: "Delegate Scout",
        description: "Support growing delegates! Delegate OP to an active delegate managing less than 5k OP.",
        image_url: "/badges/SPECIAL BADGE_04_02.png"
      },
      badge_type: "delegate_scout",
      badge_data: {
        badge_type: "delegate_scout"
      },
      rewards: [
        {
          type: "Points",
          amount: 330
        }
      ]
    }
  ]
end

module TrackData
  NEWCOMER_TRACK = {
    display_data: {
      title: "First Things First",
      description: "Kick off your Govquests journey by setting up your profile.",
      background_gradient: {
        from_color: "#696EDE",
        to_color: "#EC61CE"
      }
    },
    badge_display_data: {
      title: "Profile Unlocked",
      description: "Kick off your Govquests journey by setting up your profile.",
      image_url: "/badges/QUEST BADGE_01_06.png"
    },
    quests: [
      "Unlock Your Profile",
      "Gitcoin Score",
      "OP Holder"
    ]
  }

  DELEGATE_TRACK = {
    display_data: {
      title: "Delegate Starter Guide",
      description: "Master the essentials of governance to establish yourself as a trusted delegate.",
      background_gradient: {
        from_color: "#B95FC2",
        to_color: "#F8808E"
      }
    },
    badge_display_data: {
      title: "Delegate Starter Guide",
      description: "Master the essentials of governance to establish yourself as a trusted delegate.",
      image_url: "/badges/QUEST BADGE_02_06.png"
    },
    quests: [
      "Governance 101",
      "Become a Delegate",
      "Delegate Statement",
      "First Vote Milestone"
    ]
  }

  DELEGATION_WITH_PURPOSE = {
    display_data: {
      title: "Delegation with Purpose",
      description: "Dive deep into the delegation process and make informed choices to empower Optimism governance.",
      background_gradient: {
        from_color: "#D07C9A",
        to_color: "#FAC995"
      }
    },
    badge_display_data: {
      title: "Informed Delegator",
      description: "Dive deep into the delegation process and make informed choices to empower Optimism governance.",
      image_url: "/badges/QUEST BADGE_03_06.png"
    },
    quests: [
      "Quick Guide: Understand Delegation",
      "Become a Delegator"
    ]
  }

  GOVERNANCE_TRACK = {
    display_data: {
      title: "Governance Engagement",
      description: "Establish a trusted presence in the Optimism Collective with a verified identity and active participation.",
      background_gradient: {
        from_color: "#FF80ED",
        to_color: "#8FD4C7"
      }
    },
    badge_display_data: {
      title: "OP Promising Contributor",
      description: "Establish a trusted presence in the Optimism Collective with a verified identity and active participation.",
      image_url: "/badges/QUEST BADGE_05_06.png"
    },
    quests: [
      "Claim Your Identity",
      "OP Active Debater",
      "OP Collective First Like",
      "Proven Dedication: 3 Votes in a Row"
    ]
  }

  TRACKS = [
    NEWCOMER_TRACK,
    DELEGATE_TRACK,
    DELEGATION_WITH_PURPOSE,
    GOVERNANCE_TRACK
  ]
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
      title: "Verify your ENS name",
      description: "Connect with the Ethereum address that has your ENS name."
    },
    action_data: {
      action_type: "ens"
    }
  }

  # VERIFY_POSITION_ACTION = {
  #   action_type: "verify_position",
  #   display_data: {
  #     title: "Verify your position",
  #     description: "Click to verify your status as a Top 100 Delegate."
  #   },
  #   action_data: {
  #     action_type: "verify_position",
  #     should_be_higher_than: 100
  #   }
  # }

  VERIFY_DELEGATE_ACTION = {
    action_type: "verify_delegate",
    display_data: {
      title: "Become a Delegate",
      description: "<ul><li>Connect your wallet at <a href='https://vote.optimism.io/' target='_blank' rel='noopener noreferrer' >Agora</a> - the home of Optimism voters.</li><li>At Agora, to become a delegate, you must have OP tokens <strong>delegated to your address.</strong> </li><li>That means that someone has to delegate their tokens to you, or you can delegate your own tokens to yourself, by following Agora's instructions. </li></ul>"
    },
    action_data: {
      action_type: "verify_delegate"
    }
  }

  VERIFY_DELEGATE_STATEMENT = {
    action_type: "verify_delegate_statement",
    display_data: {
      title: "Delegate Statement",
      description: "<ul><li>Watch <a href='https://www.loom.com/share/4833b161f3514e82adbf8d5445eb3cb6' target='_blank' rel='noopener noreferrer'>this cool video</a> about how to create your delegate statement (optional).</li><li><strong>Write and publish your delegate statement <a href='https://vote.optimism.io/' target='_blank' rel='noopener noreferrer'>at Agora</a>.</strong><ul><em>Here's a suggested format for your delegate statement:</em><ul><li>A brief introduction about your background in crypto and what makes you a valuable candidate.</li><li>Your thoughts on the <a href='https://www.optimism.io/vision' target='_blank' rel='noopener noreferrer'>Optimistic Vision</a>.</li><li>Insights on the first three articles of the <a href='https://gov.optimism.io/t/working-constitution-of-the-optimism-collective/55' target='_blank' rel='noopener noreferrer'>Working Constitution</a></li><li>Your favorite crypto projects.</li></ul></ul></li><li>Make your own communication thread on <a href='https://gov.optimism.io/' target='_blank' rel='noopener noreferrer'>Op Collective's Forum</a> (optional). <a href='https://gov.optimism.io/c/delegates/delegate-updates/45' target='_blank' rel='noopener noreferrer'>You can find some inspiration here</a>!</li><li>After you have published your delegate statement, click the submit button to complete the quest.</li></ul>"
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

  HOLDS_OP = {
    action_type: "holds_op",
    display_data: {
      title: "Verify OP balance",
      description: "<ul><li>If you have not done it yet, connect your wallet.</li><li>Click to verify, we'll check if you have OP tokens.</li><li>Submit!</li></ul>"
    },
    action_data: {
      action_type: "holds_op"
    }
  }

  BECOME_DELEGATOR = {
    action_type: "become_delegator",
    display_data: {
      title: "Become a Delegator",
      description: "<ul><li>Connect your wallet at <a href='https://vote.optimism.io/' target='_blank' rel='noopener noreferrer'>Agora</a></li><li>Delegate OP to a chosen delegate or a community member.</li><li>Submit for completion.</li></ul>"
    },
    action_data: {
      action_type: "become_delegator"
    }
  }

  UNDERSTAND_DELEGATION_ACTIONS = [
    {
      action_type: "read_content_inapp",
      display_data: {
        title: "Understanding OP Token Power",
        description: "<ul><li>OP tokens give holders voting rights on crucial decisions for the Collective</li><li>While this empowers everyday users to shape the system's development, it's a significant responsibility. That's why you can delegate your voting power to community members who have volunteered to actively participate in Token House governance</li><li>If you are a delegate, you can also delegate part of your tokens tosupport and empower other delegates</li><li>A strong governance system benefits the entire Superchain, including you as a token holder</li></ul>"
      },
      action_data: {
        action_type: "read_content_inapp"
      }
    },
    {
      action_type: "read_content_inapp",
      display_data: {
        title: "Key Points About Delegation",
        description: "<ul><li>Delegates are community volunteers dedicated to active governance</li><li>They represent your interests in key decisions</li><li>You maintain 100% ownership of your tokens while delegating</li><li>You're free to undelegate or switch delegates anytime</li></ul>"
      },
      action_data: {
        action_type: "read_content_inapp"
      }
    },
    {
      action_type: "read_content_inapp",
      display_data: {
        title: "How can you actually do it?",
        description: "<ul><li>Watch this <a href='https://www.youtube.com/watch?v=pOjAOnUr3EU' target='_blank' rel='noopener noreferrer'>cool video</a> to understand how you can delegate your OP tokens.</li></ul>"
      },
      action_data: {
        action_type: "read_content_inapp"
      }
    },
    {
      action_type: "read_content_inapp",
      display_data: {
        title: "Selecting Your Delegate",
        description: "<ul><li>Review delegate statements carefully on <a href='https://vote.optimism.io/delegates' target='_blank' rel='noopener noreferrer'>Agora</a> - your choice impacts the ecosystem;</li><li>Evaluate delegates through their activity and contributions in the <a href='https://gov.optimism.io/c/delegates/41' target='_blank' rel='noopener noreferrer'>Optimism Governance Forum</a> ;</li><li>Use <a href='https://dune.com/optimismfnd/optimism-op-token-house' target='_blank' rel='noopener noreferrer'>this ranking system</a> to compare delegates by voting power, number of delegators, and other metrics.</li></ul>"
      },
      action_data: {
        action_type: "read_content_inapp"
      }
    }
  ]

  GOVERNANCE_VOTER_PARTICIPATION = {
    action_type: "governance_voter_participation",
    display_data: {
      title: "3 Consecutive Votes",
      description: "Vote on 3 different proposals and justify your choices (minimum 50 characters per justification)."
    },
    action_data: {
      action_type: "governance_voter_participation"
    }
  }

  OP_ACTIVE_DEBATER = {
    action_type: "op_active_debater",
    display_data: {
      title: "Active Debater",
      description: "<ul><li>Visit <a href='https://op-chat.bleu.builders/forum/latest-topics' target='_blank' rel='noopener noreferrer'>GovSummarizer</a> to browse the latest OP Collective topics;</li><li>Select 2 different discussions and click to access the original posts on OP Collective;</li><li>Contribute with meaningful comments (minimum 50 words each) in both discussions</li></ul>"
    },
    action_data: {
      action_type: "op_active_debater"
    }
  }

  OP_FORUM_CONTRIBUTOR = {
    action_type: "op_forum_contributor",
    display_data: {
      title: "OP Forum contributor",
      description: "<ul><li>Create a new post with meaningful content (minimum 200 characters);</li><li>Confirm community engagement (at least one like on your post).</li></ul>"
    },
    action_data: {
      action_type: "op_forum_contributor"
    }
  }

  QUESTS = [
    {
      display_data: {
        title: "OP Collective First Like",
        intro: "Create valuable content on OP Collective and get endorsed by at least one community member through a like or reinforcement on your post!",
        requirements: "To complete this quest, you'll need to authorize GovQuest to access your Discourse Account. Haven't connected your account yet? Complete <a href='/quests/claim-your-identity'>this quest</a> first to get started."
      },
      badge_display_data: {
        title: "OP Collective First Like",
        image_url: "/badges/QUEST BADGE_05_02.png"
      },
      audience: "AllUsers",
      rewards: [{type: "Points", amount: 165}],
      actions: [OP_FORUM_CONTRIBUTOR]
    },
    {
      display_data: {
        title: "Claim Your Identity",
        intro: "Building a strong reputation in the Optimism Collective starts with having a <strong>Ethereum Name Service (ENS)</strong>, and also a <strong>recognizable name</strong> in the Governance Forum. A unique identity helps the community remember you and <strong>connects your ideas to a trusted name.</strong> Let’s take the first step towards establishing your presence in OP governance!",
        image_url: "https://example.com/discourse-verification.jpg",
        requirements: "<span>To complete this quest, you need to have:</span> <ul><li>A <strong>ENS</strong> — if you don't have it, <a href='https://ens.domains/' target='_blank' rel='noopener noreferrer'>register your ENS here</a> and remember to <strong>choose a distinct username</strong> that represents you (like yourname.eth).</li> <li>A <strong>Discourse account</strong> on <strong>Optimism Governance Forum</strong> — if you also don't have it, <a href='https://gov.optimism.io/' target='_blank' rel='noopener noreferrer'>create your account here.</a> We recommend you to use your ENS as username so you can get easily recognizable.</li></ul>"
      },
      badge_display_data: {
        title: "Claim Your Identity",
        image_url: "/badges/QUEST BADGE_05_04.png"
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
      badge_display_data: {
        title: "Profile Unlocked",
        image_url: "/badges/QUEST BADGE_01_04.png"
      },
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
      badge_display_data: {
        title: "Governance 101",
        image_url: "/badges/QUEST BADGE_02_04.png"
      },
      rewards: [{type: "Points", amount: 165}],
      actions: READ_DOCUMENT_ACTIONS
    },
    {
      display_data: {
        title: "Gitcoin Score",
        intro: "Connect your Gitcoin Passport and verify your Unique Humanity Score to help strengthen our community. It's quick and easy, and you'll be contributing to a more secure ecosystem!",
        image_url: "https://example.com/advanced-governance.jpg",
        requirements: "Your Unique Humanity Score must be 20 or higher to complete this quest. Not there yet? <a href='https://support.passport.xyz/passport-knowledge-base/using-passport/scoring-20-for-humans'>Check some tips on how to increase your score.</a>"
      },
      badge_display_data: {
        title: "Gitcoin Human",
        image_url: "/badges/QUEST BADGE_01_01.png"
      },
      audience: "Delegates",
      rewards: [{type: "Points", amount: 55}],
      actions: [GITCOIN_ACTION]
    },

    # {
    #   display_data: {
    #     title: "Top 100 Delegates",
    #     intro: "Have you reached the Top 100 Delegates in Season 6? Let’s check your ranking and, if you’re among the top, celebrate your achievement with a reward!",
    #     image_url: "https://example.com/advanced-governance.jpg",
    #     requirements: "You need to be a delegate to do this quest! If you’re not one, start with Become Delegate Quest."
    #   },
    #   badge_display_data: {
    #     title: "Top 100 Delegates",
    #     image_url: "https://example.com/advanced-governance.jpg"
    #   },
    #   audience: "Delegates",
    #   rewards: [{type: "Points", amount: 165}],
    #   actions: [VERIFY_POSITION_ACTION]
    # },
    {
      display_data: {
        title: "Become a Delegate",
        intro: "Start your journey as a delegate in the Optimism community! This quest will guide you through the essential steps to become a representative within the ecosystem and share your ideas. Let’s get started!",
        image_url: "https://example.com/governance101.jpg",
        requirements: "This quest is for new delegates — those who become delegates after opening this content. If you're already a delegate, try referring new delegates to earn rewards!"
      },
      badge_display_data: {
        title: "Govquests new delegate",
        image_url: "/badges/QUEST BADGE_02_01.png"
      },
      quest_type: "Governance",
      audience: "NonDelegates",
      rewards: [{type: "Points", amount: 1000}],
      actions: [VERIFY_DELEGATE_ACTION]
    },
    {
      display_data: {
        title: "Delegate Statement",
        intro: "Creating a delegate statement helps you communicate your values and priorities within the Optimism governance. It allows delegators to make informed decisions about whom to support.",
        image_url: "https://example.com/governance101.jpg",
        requirements: "This quest is for delegates who don't have their delegate statement yet. If you already have one, take a look in the other quests for delegates!"
      },
      badge_display_data: {
        title: "Delegate Statement",
        image_url: "/badges/QUEST BADGE_02_02.png"
      },
      quest_type: "Governance",
      audience: "Delegates",
      rewards: [{type: "Points", amount: 330}],
      actions: [VERIFY_DELEGATE_STATEMENT]
    },
    {
      display_data: {
        title: "First Vote Milestone",
        intro: "As a delegate, casting your first vote is an important step in shaping the future. Step up, participate, and make your mark with your first vote!",
        image_url: "https://example.com/governance101.jpg",
        requirements: "To complete this quest, you need to <strong>be a registered delegate</strong> — if you’re not, start with Become Delegate Quest — and <strong>not have cast a vote</strong> yet."
      },
      badge_display_data: {
        title: "First Vote Milestone",
        image_url: "/badges/QUEST BADGE_02_03.png"
      },
      quest_type: "Governance",
      audience: "Delegates",
      rewards: [{type: "Points", amount: 330}],
      actions: [VERIFY_AGORA, VERIFY_FIRST_VOTE]
    },
    {
      display_data: {
        title: "OP Holder",
        intro: "Having OP tokens in your wallet is your gateway to participating in the Optimism ecosystem! This simple quest verifies your OP balance, unlocking access to essential governance activities like becoming a delegate or participating in delegation. Think of it as your first step into active participation in the Optimism community.",
        image_url: "https://example.com/governance101.jpg"
      },
      quest_type: "Governance",
      badge_display_data: {
        title: "OP Holder",
        image_url: "/badges/QUEST BADGE_01_02.png"
      },
      audience: "AllUsers",
      rewards: [{type: "Points", amount: 55}],
      actions: [HOLDS_OP]
    },
    {
      display_data: {
        title: "Become a Delegator",
        intro: "Take the first step in your delegation journey within the Optimism ecosystem! This quest encourages you to delegate OP to someone. Let’s get started on empowering the community!",
        image_url: "https://example.com/governance101.jpg",
        requirements: "To complete this quest, you have to be an OP holder. If you don't have OP in your wallet, complete the OP Holder quest first [<a href='/quests/op-holder'>link</a>]."
      },
      badge_display_data: {
        title: "Govquests New Delegator",
        image_url: "/badges/QUEST BADGE_03_01.png"
      },
      audience: "AllUsers",
      rewards: [{type: "Points", amount: 330}],
      actions: [BECOME_DELEGATOR]
    },
    {
      display_data: {
        title: "Quick Guide: Understand Delegation",
        intro: "Whether you're a token holder looking to participate in governance or a delegate wanting to support other delegates, understanding delegation is your first step into active participation in the ecosystem."
      },
      badge_display_data: {
        title: "Informed Delegator",
        image_url: "/badges/QUEST BADGE_03_04.png"
      },
      audience: "AllUsers",
      rewards: [{type: "Points", amount: 55}],
      actions: UNDERSTAND_DELEGATION_ACTIONS
    },
    {
      display_data: {
        title: "Proven Dedication: 3 Votes in a Row",
        intro: "Show your commitment as an OP Delegate by voting on 3 consecutive proposals! Your consistent participation helps shape the future of the ecosystem.",
        requirements: "To complete this quest you need to be a delegate. If you're not one yet, start with <a href='/quests/become-a-delegate'>this quest</a>."
      },
      badge_display_data: {
        title: "3 Votes in a Row",
        image_url: "/badges/QUEST BADGE_05_03.png"
      },
      audience: "Delegates",
      rewards: [{type: "Points", amount: 330}],
      actions: [GOVERNANCE_VOTER_PARTICIPATION]
    },
    {
      display_data: {
        title: "OP Active Debater",
        intro: "This quest encourages you to engage meaningfully in forum discussions, sharing your thoughts and contributing to the community's growth. Let's foster valuable conversations together!",
        requirements: "To complete this quest, you'll need to authorize GovQuest to access your Discourse Account. Haven't connected your account yet? Complete <a href='/quests/claim-your-identity'>this quest</a> first to get started."
      },
      badge_display_data: {
        title: "OP Active Debater",
        image_url: "/badges/QUEST BADGE_05_01.png"
      },
      audience: "AllUsers",
      rewards: [{type: "Points", amount: 165}],
      actions: [OP_ACTIVE_DEBATER]
    }
  ]
end

def create_quests_and_actions
  puts "Creating quests, actions, and reward pools..."

  quest_id_map = {}

  QuestData::QUESTS.each_with_index do |quest_data, index|
    # Create quest and its reward pools
    quest_id = QuestCreation.create_quest_with_rewards(quest_data)
    quest_id_map[quest_data[:display_data][:title]] = quest_id

    puts "Created quest: #{quest_data[:display_data][:title]} (#{quest_id})"
    puts "Created reward pools for quest rewards: #{quest_data[:rewards].inspect}"

    # Create and associate actions
    quest_data[:actions].each_with_index do |action_data, index|
      action_id = ActionCreation.create_action(action_data)
      QuestCreation.associate_action_with_quest(quest_id, action_id, index + 1)
      puts "Created and associated action: #{action_data[:display_data][:title]} (#{action_id}) with quest #{quest_id} at position #{index + 1}"
    end

    badge_display_data = quest_data[:badge_display_data].merge({
      sequence_number: index + 1
    })

    badge_id = BadgeCreation.create_badge(badge_display_data, quest_id, "Quest")

    puts "Completed quest: #{quest_data[:display_data][:title]} (#{quest_id}) with #{quest_data[:actions].size} actions and badge #{badge_id}"
    puts "---"
  end

  puts "All quests created with their actions and reward pools successfully!"
  quest_id_map
end

def create_tracks(quest_id_map)
  puts "Creating tracks..."

  TrackData::TRACKS.each_with_index do |track_data, index|
    track_id = TrackCreation.create_track_with_quests(track_data, quest_id_map)

    badge_display_data = track_data[:badge_display_data].merge({
      sequence_number: index + 1
    })

    badge_id = BadgeCreation.create_badge(badge_display_data, track_id, "Track")

    puts "Created track: #{track_data[:display_data][:title]} (#{track_id})"
    puts "Associated quests: #{track_data[:quests].join(", ")}"
    puts "With badge: #{badge_id}"
    puts "---"
  end

  puts "All tracks created with their quests successfully!"
end

def create_special_badges
  puts "Creating special badges..."

  SpecialBadgeData::SPECIAL_BADGES.each do |badge_data|
    badge_id = SpecialBadgeCreation.create_special_badge_with_rewards(badge_data)
    puts "Created special badge: #{badge_data[:display_data][:title]} (#{badge_id})"
    puts "With rewards: #{badge_data[:rewards].inspect}"
    puts "---"
  end

  puts "All special badges created successfully!"
end

def create_tiers
  puts "Creating tiers..."

  TierData::TIERS.each do |tier_data|
    TierCreation.create_tiers(tier_data)
    puts "Created tier: #{tier_data[:display_data][:title]}"
    puts "---"
  end
end

def create_all
  quest_id_map = create_quests_and_actions
  create_tracks(quest_id_map)
  create_special_badges
  create_tiers
end

create_all
