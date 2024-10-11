RSpec.shared_context "authenticated user" do
  let(:user_email) { "authenticated@example.com" }
  let(:user_address) { "0xAuthenticatedUser" }
  let(:chain_id) { 1 }
  let(:user_id) { create_user(email: user_email, address: user_address, chain_id: chain_id) }

  before do
    allow_any_instance_of(GraphqlController).to receive(:current_user).and_return(
      Authentication::UserReadModel.find_by(user_id: user_id)
    )
    allow_any_instance_of(GraphqlController).to receive(:context).and_return(
      {session: {user_id: user_id}, current_user: Authentication::UserReadModel.find_by(user_id: user_id)}
    )
  end
end
