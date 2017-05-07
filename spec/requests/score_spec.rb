require 'rails_helper'

describe 'Score CRUD', type: :request do 
  let(:user) { FactoryGirl.create(:participant_user) }
  let(:experiment) { FactoryGirl.create(:experiment) }
  let(:sample) { FactoryGirl.create(:sample) }
  let(:token) { FactoryGirl.create(:oauth_token, resource_owner_id: user.id) }

  context 'PUT /scores' do 
    before do
      put '/v3/scores',
      params: { 
        experiment_id: experiment.id,
        sample_id: sample.id,
        rating: 0.5
      },
      headers: { 'Authorization' => "Bearer #{token.token}" }
    end

    let(:result) { JSON.parse(response.body) }

    it 'should create a score' do 
      expect(response.code).to eql('201')
    end

    it 'should set the proper ids' do
      expect(result['_embedded']["user"]["id"])
        .to eql(user.id)
      expect(result['_embedded']["experiment"]["id"])
        .to eql(experiment.id)
      expect(result['_embedded']["sample"]["id"])
        .to eql(sample.id)
    end

    context 'with invalid/missing parameters' do 
      before do
        put '/v3/scores', 
        params: {
          experiment_id: experiment.id,
          sample_id: sample.id
        },
        headers: { 'Authorization' => "Bearer #{token.token}" }
      end
      it 'should enforce required' do 
        expect(response.code).to eql('400')
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end
end