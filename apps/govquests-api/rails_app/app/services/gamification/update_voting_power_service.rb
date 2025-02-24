module Gamification
  class UpdateVotingPowerService
    class TierNotFound < StandardError; end

    def initialize
      @command_bus = Rails.configuration.command_bus
    end

    def call(user_id:)
      user = Authentication::UserReadModel.find_by(user_id: user_id)
      raise UserNotFound unless user

      delegate = fetch_delegate_data(user.address)
      voting_power = calculate_voting_power(delegate)

      update_voting_power(user_id, voting_power)
      update_tier(user_id, voting_power[:total_voting_power])
    end

    private

    def fetch_delegate_data(address)
      agora_api.get_delegate(address)
    rescue => e
      raise DelegateDataFetchError, "Failed to fetch delegate data: #{e.message}"
    end

    def calculate_voting_power(delegate)
      total_voting_power_raw = delegate.dig("votingPower", "total").to_i
      voting_power_relative_to_votable_supply = delegate.dig("relativeVotingPowerToVotableSupply").to_f

      total_voting_power = (BigDecimal(total_voting_power_raw) / BigDecimal("1e18")).to_f

      {
        total_voting_power:,
        voting_power_relative_to_votable_supply:
      }
    end

    def update_voting_power(profile_id, voting_power)
      @command_bus.call(Gamification::UpdateVotingPower.new(
        profile_id:,
        total_voting_power: voting_power[:total_voting_power],
        voting_power_relative_to_votable_supply: voting_power[:voting_power_relative_to_votable_supply]
      ))
    end

    def update_tier(profile_id, voting_power)
      tiers = TierReadModel.ordered_by_progression
      new_tier = find_appropriate_tier(tiers, voting_power)
      raise TierNotFound unless new_tier

      @command_bus.call(Gamification::AchieveTier.new(
        profile_id: profile_id,
        tier_id: new_tier.tier_id
      ))
    end

    def find_appropriate_tier(tiers, voting_power)
      tiers.reverse.find do |tier|
        min = tier.min_delegation
        max = tier.max_delegation

        if max.nil?
          voting_power >= min
        elsif max == 0
          voting_power == 0
        else
          voting_power > 0 && voting_power >= min && voting_power <= max
        end
      end
    end

    def agora_api
      @agora_api ||= AgoraApi::Client.new
    end
  end
end
