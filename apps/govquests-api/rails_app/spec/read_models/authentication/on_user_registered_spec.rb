require "rails_helper"

RSpec.describe Authentication::OnUserRegistered do
  let(:handler) { described_class.new }
  let(:user_id) { SecureRandom.uuid }
  let(:email) { "test@example.com" }
  let(:user_type) { "non_delegate" }
  let(:address) { "0x1234567890abcdef" }
  let(:chain_id) { 1 }

  describe "#call" do
    context "when user does not exist" do
      it "creates a new user when handling UserRegistered event" do
        event = Authentication::UserRegistered.new(data: {
          user_id: user_id,
          email: email,
          user_type: user_type,
          address: address,
          chain_id: chain_id
        })

        expect {
          handler.call(event)
        }.to change(Authentication::UserReadModel, :count).by(1)

        user = Authentication::UserReadModel.find_by(user_id: user_id)
        expect(user.email).to eq(email)
        expect(user.user_type).to eq(user_type)
        expect(user.wallets.first["address"]).to eq(address)
        expect(user.wallets.first["chain_id"]).to eq(chain_id)
      end
    end

    context "when user already exists" do
      let!(:existing_user) do
        Authentication::UserReadModel.create!(
          user_id: user_id,
          email: "old@example.com",
          user_type: "delegate",
          wallets: [{address: "0x0987654321fedcba", chain_id: 2}]
        )
      end

      it "updates existing user when handling UserRegistered event" do
        event = Authentication::UserRegistered.new(data: {
          user_id: user_id,
          email: email,
          user_type: user_type,
          address: address,
          chain_id: chain_id
        })

        expect {
          handler.call(event)
        }.not_to change(Authentication::UserReadModel, :count)

        existing_user.reload
        expect(existing_user.email).to eq(email)
        expect(existing_user.user_type).to eq(user_type)
        expect(existing_user.wallets.first["address"]).to eq(address)
        expect(existing_user.wallets.first["chain_id"]).to eq(chain_id)
      end
    end

    it "does not create duplicate users when handling UserRegistered event" do
      Authentication::UserReadModel.create!(
        user_id: user_id,
        email: email,
        user_type: user_type,
        wallets: [{address: address, chain_id: chain_id}]
      )

      event = Authentication::UserRegistered.new(data: {
        user_id: user_id,
        email: email,
        user_type: user_type,
        address: address,
        chain_id: chain_id
      })

      expect {
        handler.call(event)
      }.not_to change(Authentication::UserReadModel, :count)

      user = Authentication::UserReadModel.find_by(user_id: user_id)
      expect(user.email).to eq(email)
    end
  end
end
