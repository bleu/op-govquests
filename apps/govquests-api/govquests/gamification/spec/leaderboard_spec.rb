require "spec_helper"

RSpec.describe Gamification::Leaderboard do
  let(:leaderboard_id) { SecureRandom.uuid }
  let(:leaderboard) { described_class.new(leaderboard_id) }

  describe "#update_score" do
    it "creates LeaderboardUpdated events for each score update" do
      profile_id1 = SecureRandom.uuid
      profile_id2 = SecureRandom.uuid
      profile_id3 = SecureRandom.uuid

      leaderboard.update_score(profile_id1, 300)
      leaderboard.update_score(profile_id2, 500)
      leaderboard.update_score(profile_id3, 300)

      events = leaderboard.unpublished_events.to_a

      expect(events.size).to eq(3)
      expect(events[0]).to be_a(Gamification::LeaderboardUpdated)
      expect(events[1]).to be_a(Gamification::LeaderboardUpdated)
      expect(events[2]).to be_a(Gamification::LeaderboardUpdated)
    end

    it "updates score multiple times for the same profile correctly" do
      profile_id = SecureRandom.uuid

      leaderboard.update_score(profile_id, 100)
      leaderboard.update_score(profile_id, 200)

      events = leaderboard.unpublished_events.to_a

      expect(events.size).to eq(2)
      scores = leaderboard.instance_variable_get(:@entries)
      expect(scores[profile_id]).to eq(200)
    end

    it "orders leaderboard entries based on score descending" do
      profile_id1 = SecureRandom.uuid
      profile_id2 = SecureRandom.uuid

      leaderboard.update_score(profile_id1, 100)
      leaderboard.update_score(profile_id2, 200)

      entries = leaderboard.instance_variable_get(:@entries).sort_by { |_, score| -score }
      expect(entries.first[0]).to eq(profile_id2)
      expect(entries.last[0]).to eq(profile_id1)
    end

    it "handles updating score with negative values" do
      profile_id = SecureRandom.uuid

      leaderboard.update_score(profile_id, -50)

      events = leaderboard.unpublished_events.to_a
      event = events.first

      expect(event.data[:score]).to eq(-50)
    end
  end
end
