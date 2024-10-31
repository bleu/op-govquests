require "spec_helper"

RSpec.describe Authentication::User do
  let(:user_id) { SecureRandom.uuid }
  let(:user) { described_class.new(user_id) }

  describe "#register" do
    context "when registering a new user" do
      it "creates a UserRegistered event with correct data" do
        email = "test@example.com"
        user_type = "delegate"
        address = "0x1234567890abcdef"
        chain_id = 1

        user.register(email, user_type, address, chain_id)
        events = user.unpublished_events.to_a

        expect(events.size).to eq(1)
        event = events.first

        expect(event).to be_a(Authentication::UserRegistered)
        expect(event.data[:user_id]).to eq(user_id)
        expect(event.data[:email]).to eq(email)
        expect(event.data[:user_type]).to eq(user_type)
        expect(event.data[:address]).to eq(address)
        expect(event.data[:chain_id]).to eq(chain_id)
      end
    end

    context "when registering a user with missing email" do
      it "creates a UserRegistered event with nil email" do
        user_type = "delegate"
        address = "0x1234567890abcdef"
        chain_id = 1

        user.register(nil, user_type, address, chain_id)
        event = user.unpublished_events.first

        expect(event.data[:email]).to be_nil
      end
    end

    context "when registering an already registered user" do
      it "raises AlreadyRegistered error" do
        user.register("test@example.com", "delegate", "0x1234567890abcdef", 1)

        expect {
          user.register("new@example.com", "non_delegate", "0x0987654321fedcba", 2)
        }.to raise_error(Authentication::User::AlreadyRegistered)
      end
    end
  end

  describe "#log_in" do
    context "when logging in a registered user" do
      it "creates a UserLoggedIn event with correct data" do
        user.register("test@example.com", "delegate", "0x1234567890abcdef", 1)
        session_token = SecureRandom.hex(16)
        timestamp = Time.now

        user.log_in(session_token, timestamp)
        events = user.unpublished_events.to_a

        expect(events.size).to eq(2)
        event = events.last

        expect(event).to be_a(Authentication::UserLoggedIn)
        expect(event.data[:user_id]).to eq(user_id)
        expect(event.data[:session_token]).to eq(session_token)
        expect(event.data[:timestamp]).to eq(timestamp)
      end
    end

    context "when logging in an unregistered user" do
      it 'raises "User not registered" error' do
        session_token = SecureRandom.hex(16)
        timestamp = Time.now

        expect {
          user.log_in(session_token, timestamp)
        }.to raise_error(RuntimeError, "User not registered")
      end
    end

    context "when logging in multiple times" do
      it "records multiple sessions" do
        user.register("test@example.com", "delegate", "0x1234567890abcdef", 1)
        session_token1 = SecureRandom.hex(16)
        timestamp1 = Time.now
        user.log_in(session_token1, timestamp1)

        session_token2 = SecureRandom.hex(16)
        timestamp2 = Time.now + 60
        user.log_in(session_token2, timestamp2)

        sessions = user.instance_variable_get(:@sessions)
        expect(sessions.size).to eq(2)
        expect(sessions[0][:session_token]).to eq(session_token1)
        expect(sessions[0][:logged_in_at]).to eq(timestamp1)
        expect(sessions[1][:session_token]).to eq(session_token2)
        expect(sessions[1][:logged_in_at]).to eq(timestamp2)
      end
    end
  end
end
