require "rails_helper"

RSpec.describe Authentication::OnUserLoggedIn do
  let(:handler) { described_class.new }
  let(:user_id) { SecureRandom.uuid }
  let(:session_token) { SecureRandom.hex(16) }
  let(:timestamp) { Time.current }

  describe "#call" do
    before do
      Rails.configuration.command_bus.call(Authentication::RegisterUser.new(
        user_id: user_id,
        email: "",
        user_type: "non_delegate",
        address: "0x0987654321fedcba",
        chain_id: 2
      ))
    end

    it "creates a new user session when handling UserLoggedIn event" do
      event = Authentication::UserLoggedIn.new(data: {
        user_id: user_id,
        session_token: session_token,
        timestamp: timestamp
      })

      expect {
        handler.call(event)
      }.to change(Authentication::SessionReadModel, :count).by(1)

      session = Authentication::SessionReadModel.last
      expect(session.user_id).to eq(user_id)
      expect(session.session_token).to eq(session_token)
      expect(session.logged_in_at).to eq(timestamp)
      expect(session.logged_out_at).to be_nil
    end
  end
end
