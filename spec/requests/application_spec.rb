require 'rails_helper'

describe 'Application CRUD', type: :request do 
  let(:oauth_token) { FactoryGirl.create(:oauth_token) }
  let(:user) { FactoryGirl.create(:user) }

  let(:result) { JSON.parse(response.body) }

  context 'PUT /application' do
    before do
      put '/v3/application',
        params: {
          name: 'test application', 
          redirect_uri: 'https://test.net/catch'
        },
        headers: {
          Authorization: "Bearer #{oauth_token.token}"
        }
    end

    it 'should create an application' do 
      expect(response.code).to eql('201')
      expect(Doorkeeper::Application.where(id: result['id'])).to exist
    end
  end
end
