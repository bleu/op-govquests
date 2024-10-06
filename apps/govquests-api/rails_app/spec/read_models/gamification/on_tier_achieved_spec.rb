# RSpec.describe Gamification::OnTierAchieved do
#   let(:handler) { described_class.new }
#   let(:profile_id) { SecureRandom.uuid }
#   let(:game_profile) { Gamification::GameProfileReadModel.create!(profile_id: profile_id, tier: "1", score: 100) }

#   describe "#call" do
#     it "updates tier when handling TierAchieved event" do
#       event = Gamification::TierAchieved.new(data: {profile_id: profile_id, tier: "2"})
#       handler.call(event)

#       game_profile.reload
#       puts "Tier after reload: #{game_profile.tier.inspect}"
#       expect(game_profile.tier).to eq("2")
#     end
#   end
# end
