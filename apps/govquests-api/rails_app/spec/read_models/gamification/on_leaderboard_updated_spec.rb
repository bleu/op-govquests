require "rails_helper"

RSpec.describe Gamification::OnLeaderboardUpdated, type: :model do
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

  let(:event) do
    Gamification::LeaderboardUpdated.new(data: {
      leaderboard_id: leaderboard_id,
      profile_id: profile_id,
      score: score
    })
  end

  describe "#call" do
    it "creates or updates a LeaderboardEntryReadModel record" do
      expect {
        handler.call(event)
      }.to change(Gamification::LeaderboardEntryReadModel, :count).by(1)

      entry = Gamification::LeaderboardEntryReadModel.last
      expect(entry).to have_attributes(
        leaderboard_id: leaderboard_id,
        profile_id: profile_id,
        score: score
      )
      expect(entry.rank).to be_present
      expect(entry.leaderboard).to eq(leaderboard)
    end
  end
end
