require 'rails_helper'

describe 'Token Management', type: :request do
  let!(:user) { FactoryGirl.create(:user) }
  let(:application) { FactoryGirl.create(:application) }

  let(:results) { JSON.parse(response.body) }

  context 'application grant' do 
    before do 
      post '/v3/authorize/app',
      params: {
        client_id: client_id,
        client_secret: client_secret}
    end

    context 'with valid credentials' do
      let(:client_id) { application.uid }
      let(:client_secret) { application.secret }

      it 'should return a valid token' do
        expect(response.code).to eql('200')
        expect(results.fetch('token')).to be_a(String)
        expect(
          Doorkeeper::AccessToken.by_token(results['token']).valid?
        ).to be(true)
      end
    end

    context 'with invalid credentials' do 
      let(:client_id) { 'russia' }
      let(:client_secret) { 'BIGLY DEALS' }

      it 'should 401' do   
        expect(response.code).to eql('401')
      end
    end
  end

  context 'password grant' do 
    let(:email) { user.email }
    let(:password) { user.password }
    let(:app_token) { FactoryGirl.create(:app_token) }

    before do
      post '/v3/authorize/user', 
        params: { email: email, password: password },
        headers: { 'Turaco-Api-Key' => app_token.token }
    end

    it 'should return a valid token' do 
      expect(response.code).to eql('200')
      expect(results.fetch('token')).to be_a(String)
      expect(
        Doorkeeper::AccessToken.by_token(results['token']).valid?
      ).to be(true)
    end

    it 'should include all roles the user has as scopes' do 
      expect(results.fetch('scopes')).to eql(user.roles.pluck(:name))
    end

    context 'no token' do 
      let(:app_token) { OpenStruct.new(token: nil) }

      it 'should 401' do 
        expect(response.code).to eql('401')
      end
    end

    context 'with invalid credentials' do 
      let(:email) { 'steve@iluvbarnacles.com' }
      let(:password) { 'password' }

      it 'should 401' do
        expect(response.code).to eql('401')
      end
    end
  end
end