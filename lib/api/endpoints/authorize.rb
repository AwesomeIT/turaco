# frozen_string_literal: true
module API
  module Endpoints
    class Authorize < Grape::API
      desc 'Authorize a user'
      params do 
        requires :email, type: String, desc: 'E-Mail of user'
        requires :password, type: String, desc: 'Plaintext password'
      end
      post '/user' do
        token = env['warden'].authenticate(:user_grant)
        error!(
          { message: 'Error!', description: 'User login failed'}, 401
        ) unless token.present?

        status 200
        present(token, with: Entities::Doorkeeper::Token)
      end

      desc 'Authorize an application'
      params do 
        requires :client_id, type: String, desc: 'API Client ID'
        requires :client_secret, type: String, desc: 'API Client Secret'
      end
      post '/app' do
        declared_params = declared(params)

        app = Doorkeeper::Application.find_by(
          uid: declared_params[:client_id],
          secret: declared_params[:client_secret]
        )
        
        error!(
          { message: 'Error!',
            description: 'Application grant unsuccessful' }, 401
        ) unless app.present?

        token = Doorkeeper::AccessToken.create!(
          application_id: app.id,
          scopes: 'application'
        )

        status 200
        present(token, with: Entities::Doorkeeper::Token)
      end
    end
  end
end
