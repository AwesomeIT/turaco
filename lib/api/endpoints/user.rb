# frozen_string_literal: true
module API
  module Endpoints
    class User < Grape::API
      extend API::Meta::SimpleReads

      resource :users
      authorize_routes!

      desc 'Create a user'
      route_setting :scopes, %(administrator)
      params do
        requires :email, type: String, desc: 'User email address'
        requires :encrypted_password, type: String,
                                      desc: 'BCrypt hash of user password'
        optional :tags, type: String, desc: 'Whitespace delimited tags'
      end
      put authorize: [:write, ::User] do
        status 201

        # We skip validation because we require our clients
        # to compute the BCrypt hash.
        new_user = ::User.new(declared_hash.except(:tags))
        new_user.save(validate: false)

        new_user.tags << declared_params[:tags]
                         .split(' ') if declared_params.key?(:tags)

        Events::PostgresProducer.call(new_user)
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
        optional :tags, type: String, desc: 'Whitespace delimited tags'
      end
      post '/:id', authorize: [:write, ::User] do
        status 200
        user = ::User.accessible_by(current_ability).find(declared_params[:id])

        if declared_params.key?(:tags)
          tags = declared_hash.delete(:tags).split(' ')
          user.tags >> (user.tags.pluck(:name) - tags)
          user.tags << tags
        end

        user.update_attributes(declared_hash)
        user.save

        Events::PostgresProducer.call(user)
        present(user, with: Entities::User)
      end

      get_by_id scopes: %w(administrator),
                authorize: [:read, ::User]
    end
  end
end
