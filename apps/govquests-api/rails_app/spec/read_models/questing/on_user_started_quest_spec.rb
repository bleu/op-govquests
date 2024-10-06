# require "rails_helper"

# RSpec.describe Questing::OnUserStartedQuest do
#   let(:handler) { described_class.new }
#   let(:quest_id) { SecureRandom.uuid }
#   let(:user_id) { SecureRandom.uuid }

#   describe "#call" do
#     it "creates or updates user quest when handling UserStartedQuest event" do
#       event = Questing::UserStartedQuest.new(data: {
#         quest_id: quest_id,
#         user_id: user_id
#       })

#       expect {
#         handler.call(event)
#       }.to change(Questing::UserQuest, :count).by(1)

#       user_quest = Questing::UserQuest.find_by(quest_id: quest_id, user_id: user_id)
#       expect(user_quest.status).to eq("started")
#       expect(user_quest.started_at).not_to be_nil
#     end
#   end
# end
