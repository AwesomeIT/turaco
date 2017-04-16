require 'rails_helper'

describe 'Application CRUD', type: :request do 
  let(:admin_user) { FactoryGirl.create(:admin_user) }
  let(:oauth_token) do
    FactoryGirl.create(:oauth_token, resource_owner_id: admin_user.id)
  end

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

  context 'GET /application' do
    let(:owner_user) { FactoryGirl.create(:researcher_user) }
    let!(:applications) do 
      FactoryGirl.create_list(
        :application, 10, user: owner_user
      )
    end

    # Also overwrite the last application with this user's ID
    let!(:other_user) do
      FactoryGirl.create(:researcher_user).tap do |u|
        applications.last.user = u
        applications.last.save
      end
    end

    before do
      get '/v3/application',
        headers: {
          Authorization: "Bearer #{oauth_token.token}"
        }
    end

    context 'as an administrator' do
      before do
        oauth_token.resource_owner_id = admin_user.id
        oauth_token.save 
      end

      it 'will list all applications' do
        expect(response.status).to eql(200)
        expect(result['applications'].map { |r| r['id'].to_i })
          .to match(applications.pluck(:id))
      end
    end

    context 'as another user' do
      before do
        oauth_token.resource_owner_id = other_user.id
        oauth_token.save 
      end

      it 'will list all applications' do
        expect(response.status).to eql(200)
        expect(result['applications'].map { |r| r['id'].to_i })
          .to include(applications.last.id)
      end
    end
  end
end
