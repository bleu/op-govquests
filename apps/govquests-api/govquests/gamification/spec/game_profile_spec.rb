require "spec_helper"

RSpec.describe Gamification::GameProfile do
  let(:profile_id) { SecureRandom.uuid }
  let(:profile) { described_class.new(profile_id) }

  describe "#update_score" do
    context "when updating score with positive points" do
      it "creates a ScoreUpdated event with correct data" do
        points = 100
        profile.update_score(points)
        events = profile.unpublished_events.to_a

        expect(events.size).to eq(1)
        event = events.first

        expect(event).to be_a(Gamification::ScoreUpdated)
        expect(event.data[:profile_id]).to eq(profile_id)
        expect(event.data[:points]).to eq(points)
      end
    end

    context "when updating score with negative points" do
      it "creates a ScoreUpdated event with negative points" do
        points = -50
        profile.update_score(points)
        events = profile.unpublished_events.to_a

        expect(events.size).to eq(1)
        event = events.first

        expect(event.data[:points]).to eq(points)
      end
    end
  end

  describe "#achieve_tier" do
    it "creates a TierAchieved event with correct data" do
      tier = "Gold"
      profile.achieve_tier(tier)
      events = profile.unpublished_events.to_a

      expect(events.size).to eq(1)
      event = events.first

      expect(event).to be_a(Gamification::TierAchieved)
      expect(event.data[:profile_id]).to eq(profile_id)
      expect(event.data[:tier]).to eq(tier)
    end
  end

  describe "#earn_badge" do
    it "creates BadgeEarned events for each badge" do
      badges = ["First Login", "Quest Master", "Top Scorer"]
      badges.each { |badge| profile.earn_badge(badge) }
      events = profile.unpublished_events.to_a

      expect(events.size).to eq(3)
      badges_awarded = events.map { |e| e.data[:badge] }
      expect(badges_awarded).to eq(badges)
    end
  end

  describe "#maintain_streak" do
    it "creates a StreakMaintained event with correct data" do
      streak = 5
      profile.maintain_streak(streak)
      events = profile.unpublished_events.to_a

      expect(events.size).to eq(1)
      event = events.first

      expect(event).to be_a(Gamification::StreakMaintained)
      expect(event.data[:streak]).to eq(streak)
    end
  end

  describe "#complete_track" do
    it "creates a TrackCompleted event with correct data" do
      track = "Governance Basics"
      profile.complete_track(track)
      events = profile.unpublished_events.to_a

      expect(events.size).to eq(1)
      event = events.first

      expect(event).to be_a(Gamification::TrackCompleted)
      expect(event.data[:track]).to eq(track)
    end
  end
end
