require 'rails_helper'

describe 'User CRUD', type: :request do
  let(:token) do
    FactoryGirl.create(
      :oauth_token, resource_owner_id: FactoryGirl.create(:admin_user).id
    )
  end

  let(:result) { JSON.parse(response.body) }

  context 'PUT /users' do
    let(:email) { 'test@foo.com' }
    let(:tags) { %w(foo bar) }

    before do
      put '/v3/users',
        params: {
          email: email,
          encrypted_password: 'foobar',
          tags: tags.join(' ')
        }, 
        headers: {
          Authorization: "Bearer #{token.token}"
        }
    end

    it 'should create the user' do
      expect(response.code).to eql('201')
      expect(User.where(email: email)).to exist
      expect(User.find(result['id']).tags.pluck(:name)).to match_array(tags)
    end
  end

  context 'GET /users/self' do 
    before do
      get '/v3/users/self',
        headers: {
          Authorization: "Bearer #{token.token}"
        }
    end

    it 'should get the user associated with the current token' do 
      expect(response.code).to eql('200')
      expect(result['email']).to eql(User.find(token.resource_owner_id).email)
    end
  end

  context 'GET /users' do    
    before do
      get '/v3/users',
        headers: {
          Authorization: "Bearer #{token.token}"
        }
    end

    it 'should contain a list of all users' do
      expect(response.code).to eql('200')
      expect(result['users'].count).to eql(::User.all.count) 
    end

    context 'by id' do
      let(:some_user) { FactoryGirl.create(:participant_user) }

      before do
        get "/v3/users/#{some_user.id}",
          headers: {
            Authorization: "Bearer #{token.token}"
          }
      end

      it 'should find the correct record' do
        expect(response.code).to eql('200')
        expect(result['email']).to eql(some_user.email)
      end
    end
  end

  context 'POST /users' do
    let(:new_email) { 'new@email.com' }

    let!(:user) do
      ::User.find(token.resource_owner_id).tap { |u| u.tags << %w(foo bar baz) }
    end

    let(:new_tags) { %w(foo bar new) }

    before do
      post "/v3/users/#{token.resource_owner_id}",
        params: {
          email: new_email,
          tags: new_tags.join(' ')
        },
        headers: {
          Authorization: "Bearer #{token.token}"
        }
    end

    it 'should update the user record' do
      expect(response.code).to eql('200')
      user.reload
      expect(user.email).to eql(new_email)
      expect(user.tags.pluck(:name)).to match_array(new_tags)
    end
  end  
end