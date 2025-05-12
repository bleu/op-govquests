require_relative "../../../../rails_app/lib/safe/propose_erc20_transfer"

module Gamification
  class GameProfile
    include AggregateRoot

    def initialize(id)
      @id = id
      @score = 0
      @tier_id = nil
      @rank = nil
      @voting_power = 0
      @voting_power_relative_to_votable_supply = 0
      @delegatee_address = nil
    end

    def create
      apply GameProfileCreated.new(data: {
        profile_id: @id,
      })
    end

    def update_score(points)
      apply ScoreUpdated.new(data: {
        profile_id: @id,
        points: points
      })
    end

    def update_voting_power(total_voting_power, voting_power_relative_to_votable_supply)
      apply VotingPowerUpdated.new(data: {
        profile_id: @id,
        total_voting_power: total_voting_power,
        voting_power_relative_to_votable_supply: voting_power_relative_to_votable_supply
      })
    end

    def achieve_tier(tier_id)
      return if @tier_id == tier_id
      apply TierAchieved.new(data: {
        profile_id: @id,
        tier_id: tier_id,
      })
    end

    def update_rank(rank)
      return if @rank == rank
      apply GameProfileRankUpdated.new(data: {
        profile_id: @id,
        rank: rank
      })
    end

    def update_delegatee(delegatee_address)
      apply DelegateeUpdated.new(data: {
        profile_id: @id,
        delegatee_address: delegatee_address
      })
    end

    private

    on ScoreUpdated do |event|
      @score += event.data[:points]
    end

    on VotingPowerUpdated do |event|
      @total_voting_power = event.data[:total_voting_power],
      @voting_power_relative_to_votable_supply = event.data[:voting_power_relative_to_votable_supply]
    end

    on TierAchieved do |event|
      @tier_id = event.data[:tier_id]
    end

    on GameProfileCreated do |event|
      @tier_id = event.data[:tier_id]
    end

    on GameProfileRankUpdated do |event|
      @rank = event.data[:rank]
    end

    on GameProfileDelegateeUpdated do |event|
      @delegatee_address = event.data[:delegatee_address]
    end
  end
end
