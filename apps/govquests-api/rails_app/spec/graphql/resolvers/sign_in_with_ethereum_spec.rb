require "rails_helper"

RSpec.describe Mutations::SignInWithEthereum, type: :request do
  include_context "authenticated user"

  let(:mutation) do
    <<-GRAPHQL
      mutation($signature: String!) {
        signInWithEthereum(signature: $signature) {
          user {
            id
            email
            userType
            address
            chainId
          }
          errors
        }
      }
    GRAPHQL
  end

  context "with valid signature" do
    let(:signature) { "0xvalidsignature" }

    before do
      allow_any_instance_of(::Siwe::Message).to receive(:verify).and_return(true)
    end

    it "signs in the user successfully" do
      post "/graphql", params: {query: mutation, variables: {signature: signature}}
      json_response = JSON.parse(response.body)

      expect(json_response["data"]["signInWithEthereum"]["user"]).not_to be_nil
      expect(json_response["data"]["signInWithEthereum"]["errors"]).to be_empty
    end
  end

  context "with invalid signature" do
    let(:signature) { "0xinvalidsignature" }

    before do
      allow_any_instance_of(::Siwe::Message).to receive(:verify).and_return(false)
    end

    it "returns an error" do
      post "/graphql", params: {query: mutation, variables: {signature: signature}}
      json_response = JSON.parse(response.body)

      expect(json_response["data"]["signInWithEthereum"]["user"]).to be_nil
      expect(json_response["data"]["signInWithEthereum"]["errors"]).to include("Invalid signature")
    end
  end
end
