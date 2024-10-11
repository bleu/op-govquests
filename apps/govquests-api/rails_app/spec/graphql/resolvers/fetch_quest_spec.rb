require 'rails_helper'

RSpec.describe Resolvers::FetchQuest, type: :request do
  let!(:quest) { create(:quest_read_model) }

  describe '#resolve' do
    let(:query) do
      <<-GRAPHQL
        query($id: ID!) {
          quest(id: $id) {
            id
            questType
            audience
            status
            rewards {
              type
              amount
            }
            displayData {
              title
              intro
            }
          }
        }
      GRAPHQL
    end

    let(:variables) { { id: quest.quest_id } }

    it 'returns the requested quest' do
      post '/graphql', params: { query: query, variables: variables }
      json_response = JSON.parse(response.body)

      expect(json_response['data']['quest']['id']).to eq(quest.quest_id.to_s)
      expect(json_response['data']['quest']['questType']).to eq(quest.quest_type)
      expect(json_response['data']['quest']['audience']).to eq(quest.audience)
    end
  end
end
