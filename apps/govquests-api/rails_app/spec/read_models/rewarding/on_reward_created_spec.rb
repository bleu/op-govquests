RSpec.describe Rewarding::OnRewardCreated do
  let(:handler) { described_class.new }
  let(:reward_id) { SecureRandom.uuid }
  let(:reward_type) { "points" }
  let(:value) { 100 }
  let(:expiry_date) { Time.current + 7.days }

  describe "#call" do
    it "creates a new reward when handling RewardCreated event" do
      event = Rewarding::RewardCreated.new(data: {
        reward_id: reward_id,
        reward_type: reward_type,
        value: value,
        expiry_date: expiry_date
      })

      expect {
        handler.call(event)
      }.to change(Rewarding::RewardReadModel, :count).by(1)

      reward = Rewarding::RewardReadModel.find_by(reward_id: reward_id)
      expect(reward.reward_type).to eq(reward_type)
      expect(reward.value).to eq(value)
      expect(reward.expiry_date.to_i).to eq(expiry_date.to_i)
      expect(reward.delivery_status).to eq("Pending")
    end
  end
end
