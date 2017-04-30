# frozen_string_literal: true
module API
  module Endpoints
    class User < Grape::API
      resource :users
      authorize_routes!

      desc 'Create a user'
      route_setting :scopes, %(administrator)
      params do
        requires :email, type: String, desc: 'User email address'
        requires :encrypted_password, type: String,
                                      desc: 'BCrypt hash of user password'
      end
      put authorize: [:write, ::User] do
        status 201

        # We skip validation because we require our clients
        # to compute the BCrypt hash.
        new_user = ::User.new(declared(params).to_h)
        new_user.save(validate: false)
        new_user.reload

        present(new_user, with: Entities::User)
      end

      desc 'List all users'
      route_setting :scopes, %(administrator)
      get do
        status 200
        present(
          ::User.accessible_by(current_ability), with: Entities::Collection
        )
      end

      desc 'Return the user associated with the current token'
      get '/self' do
        status 200
        present(current_user, with: Entities::User)
      end

      desc 'Retrieve a user by ID'
      route_setting :scopes, %(administrator)
      params do
        requires :id, type: String, desc: 'User ID'
      end
      get '/:id', authorize: [:read, ::User] do
        status 200
        present(
          ::User.accessible_by(current_ability).find(declared(params)[:id]),
          with: Entities::User
        )
      end

      # TODO: individual users can reset their own passwords
      # and stuff, but need rest of scopes first
      desc 'Update a user'
      route_setting :scopes, %(administrator)
      params do
        requires :id, type: String, desc: 'User ID',
                      documentation: {
                        param_type: 'body'
                      }
        optional :email, type: String, desc: 'User email address'
        optional :encrypted_password, type: String,
                                      desc: 'BCrypt hash of user password'
      end
      post '/:id', authorize: [:write, ::User] do
        status 200
        declared_params = declared(params, include_missing: false)
        user = ::User.accessible_by(current_ability).find(declared_params[:id])
        user.update_attributes(declared_params.to_h)
        user.save

        present(user, with: Entities::User)
      end
    end
  end
end
