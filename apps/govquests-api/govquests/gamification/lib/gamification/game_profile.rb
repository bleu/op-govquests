require_relative "../../../../rails_app/lib/safe/propose_erc20_transfer"

module Gamification
  class GameProfile
    MIN_CLAIMABLE_TOKEN_AMOUNT = 30

    include AggregateRoot

    InsufficientClaimableBalance = Class.new(StandardError)
    NoActiveClaimError = Class.new(StandardError)
    AlreadyClaimingError = Class.new(StandardError)
    WrongTokenError = Class.new(StandardError)

    def initialize(id)
      @id = id
      @score = 0
      @tier_id = nil
      @track = nil
      @streak = 0
      @badges = []
      @unclaimed_tokens = {} # token_address => amount
      @active_claim = nil
      @voting_power = 0
    end

    def create
      apply GameProfileCreated.new(data: {
        profile_id: @id,
      })
    end

    def add_token_reward(token_address:, amount:, pool_id:)
      current_balance = @unclaimed_tokens[token_address] || 0
      new_balance = current_balance + amount

      apply TokenRewardAdded.new(data: {
        profile_id: @id,
        token_address: token_address,
        amount: amount,
        pool_id: pool_id,
        total_unclaimed: new_balance
      })
    end

    def start_token_claim(token_address:, user_address:)
      raise AlreadyClaimingError if @active_claim
      raise InsufficientClaimableBalance unless can_claim?(token_address)

      total = @unclaimed_tokens[token_address]

      safe_service = Safe::ProposeErc20Transfer.new(
        to_address: user_address,
        value: total,
        token_address: token_address
      )

      safe_response = safe_service.call

      apply TokenClaimStarted.new(data: {
        profile_id: @id,
        token_address: token_address,
        amount: total,
        claim_metadata: safe_response,
        user_address: user_address,
        started_at: Time.now
      })
    end

    def complete_token_claim(token_address:, claim_metadata:)
      raise NoActiveClaimError unless @active_claim
      raise WrongTokenError if @active_claim[:token_address] != token_address

      apply TokenClaimCompleted.new(data: {
        profile_id: @id,
        token_address: token_address,
        user_address: @active_claim[:user_address],
        amount: @active_claim[:amount],
        claim_metadata: claim_metadata,
        completed_at: Time.now
      })
    end

    def update_score(points)
      apply ScoreUpdated.new(data: {
        profile_id: @id,
        points: points
      })
    end

    def update_voting_power(voting_power)
      apply VotingPowerUpdated.new(data: {
        profile_id: @id,
        voting_power: voting_power
      })
    end

    def achieve_tier(tier_id)
      apply TierAchieved.new(data: {
        profile_id: @id,
        tier_id: tier_id
      })
    end

    def complete_track(track)
      apply TrackCompleted.new(data: {
        profile_id: @id,
        track: track
      })
    end

    def maintain_streak(streak)
      apply StreakMaintained.new(data: {
        profile_id: @id,
        streak: streak
      })
    end

    def earn_badge(badge)
      apply BadgeEarned.new(data: {
        profile_id: @id,
        badge: badge
      })
    end

    private

    def can_claim?(token_address)
      amount = @unclaimed_tokens[token_address] || 0
      amount >= MIN_CLAIMABLE_TOKEN_AMOUNT
    end

    on TokenRewardAdded do |event|
      token = event.data[:token_address]
      @unclaimed_tokens[token] ||= 0
      @unclaimed_tokens[token] += event.data[:amount]
    end

    on TokenClaimStarted do |event|
      @active_claim = {
        token_address: event.data[:token_address],
        amount: event.data[:amount],
        user_address: event.data[:user_address],
        claim_metadata: event.data[:claim_metadata],
        started_at: event.data[:started_at]
      }
    end

    on TokenClaimCompleted do |event|
      token = event.data[:token_address]
      @unclaimed_tokens[token] = 0
      @active_claim = nil
    end

    on ScoreUpdated do |event|
      @score += event.data[:points]
    end

    on VotingPowerUpdated do |event|
      @voting_power = event.data[:voting_power]
    end

    on TierAchieved do |event|
      @tier_id = event.data[:tier_id]
    end

    on TrackCompleted do |event|
      @track = event.data[:track]
    end

    on StreakMaintained do |event|
      @streak = event.data[:streak]
    end

    on BadgeEarned do |event|
      @badges << event.data[:badge]
    end

    on GameProfileCreated do |event|
      @tier_id = event.data[:tier_id]
    end
  end
end
