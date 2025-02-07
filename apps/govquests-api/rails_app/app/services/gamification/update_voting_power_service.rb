module Gamification
  class UpdateVotingPowerService
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
      voting_power_relative_to_votable_supply = delegate.dig("votingPowerRelativeToVotableSupply").to_f

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
      tiers = TierReadModel.order(min_delegation: :desc)
      new_tier = tiers.find { |tier| voting_power >= tier.min_delegation }
      raise TierNotFound unless new_tier

      @command_bus.call(Gamification::AchieveTier.new(
        profile_id: profile_id,
        tier_id: new_tier.tier_id
      ))
    end

    def agora_api
      @agora_api ||= AgoraApi::Client.new
    end
  end
end
