require "rails_helper"

RSpec.describe Gamification::OnLeaderboardUpdated do
  let(:handler) { described_class.new }
  let(:leaderboard_id) { SecureRandom.uuid }
  let(:profile_id) { SecureRandom.uuid }
  let(:score) { 1500 }

  let!(:leaderboard) do
    Gamification::LeaderboardReadModel.create!(
      leaderboard_id: leaderboard_id,
      name: "Top Players"
    )
  end

  describe "#call" do
    it "updates leaderboard entry when handling LeaderboardUpdated event" do
      event = Gamification::LeaderboardUpdated.new(data: {
        leaderboard_id: leaderboard_id,
        profile_id: profile_id,
        score: score
      })

      expect {
        handler.call(event)
      }.to change(Gamification::LeaderboardEntryReadModel, :count).by(1)

      entry = Gamification::LeaderboardEntryReadModel.find_by(
        leaderboard_id: leaderboard_id,
        profile_id: profile_id
      )
      expect(entry.score).to eq(score)
      expect(entry.rank).not_to be_nil
      expect(entry.leaderboard).to eq(leaderboard)
    end
  end
end
