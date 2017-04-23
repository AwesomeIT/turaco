require 'rails_helper'

describe 'Application CRUD', type: :request do 
  let(:admin_user) { FactoryGirl.create(:admin_user) }
  let(:oauth_token) do
    FactoryGirl.create(:oauth_token, resource_owner_id: admin_user.id)
  end

  let(:result) { JSON.parse(response.body) }

  context 'PUT /applications' do
    before do
      put '/v3/applications',
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

  context 'POST /applications/:id' do 
    let(:owner) { FactoryGirl.create(:researcher_user) }
    let(:application) { FactoryGirl.create(:application, user: owner) }
    let(:token) do
      FactoryGirl.create(:oauth_token, resource_owner_id: owner.id)
    end

    let(:new_name) { 'foobarbazbar' }

    before do
      post "/v3/applications/#{application.id}",
        params: { name: new_name },
        headers: {
          Authorization: "Bearer #{token.token}"
        }
    end

    it 'should update the application' do 
      application.reload
      expect(response.code).to eql('204')
      expect(application.name).to eql(new_name)
    end
  end

  context 'GET /applications/:id' do
    let(:owner) { FactoryGirl.create(:researcher_user) }
    let(:application) { FactoryGirl.create(:application, user: owner) }
    let(:token) do
      FactoryGirl.create(:oauth_token, resource_owner_id: owner.id)
    end

    before do
      get "/v3/applications/#{application.id}",
        headers: {
          Authorization: "Bearer #{token.token}"
        }
    end

    it 'can find the created application for the owner user' do
      expect(response.code).to eql('200') 
      expect(result['id']).to eql(application.id)
    end

    context 'as another user' do
      let(:token) do
        FactoryGirl.create(
          :oauth_token,
          resource_owner_id: FactoryGirl.create(:researcher_user).id
        )
      end

      it 'should 404' do
        expect(response.code).to eql('404') 
      end 
    end
  end

  context 'GET /applications' do
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

    let(:token) { oauth_token }

    before do
      get '/v3/applications',
        headers: {
          Authorization: "Bearer #{token.token}"
        }
    end

    context 'as an administrator' do
      it 'will list all applications' do
        expect(response.status).to eql(200)
        expect(result['applications'].map { |r| r['id'].to_i })
          .to include(*applications.pluck(:id))
      end
    end

    context 'as another user' do
      let(:token) do
        FactoryGirl.create(:oauth_token, resource_owner_id: other_user.id)
      end

      it 'will list all applications' do
        expect(response.status).to eql(200)
        expect(result['applications'].count).to eql(1)
        expect(result['applications'].map { |r| r['id'].to_i })
          .to include(applications.last.id)
      end
    end
  end
end
