require 'rails_helper'

describe 'Score CRUD', type: :request do 
  let(:user) { FactoryGirl.create(:participant_user) }
  let(:experiment) { FactoryGirl.create(:experiment) }
  let(:sample) { FactoryGirl.create(:sample) }
  let(:token) { FactoryGirl.create(:oauth_token, resource_owner_id: user.id) }

  context 'PUT /score' do 
    before do
      put '/v3/score',
      params: { 
        user_id: user.id,
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
      expect(result["user"]["links"].first["href"]).to eql(
        "http://www.example.com/v3/user/#{user.id}"
      )
      expect(result["experiment"]["links"].first["href"]).to eql(
        "http://www.example.com/v3/experiment/#{experiment.id}"
      )
      expect(result["sample"]["links"].first["href"]).to eql(
        "http://www.example.com/v3/sample/#{sample.id}"
      )
    end

    context 'with invalid/missing parameters' do 
      before do
        put '/v3/score', 
        params: {
          user_id: user.id,
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