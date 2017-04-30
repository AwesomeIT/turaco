# frozen_string_literal: true
module API
  module Endpoints
    class Application < Grape::API
      resource :applications
      authorize_routes!

      desc 'Create an application'
      route_setting :scopes, %(administrator)
      params do
        requires :name, type: String, desc: 'Application name'
        requires :redirect_uri,
                 type: String,
                 desc: 'OAuth redirect URI (must be HTTPS)'
      end
      put authorize: [:write, Doorkeeper::Application] do
        status 201
        declared_params = declared(params)
        Doorkeeper::Application.create(
          name: declared_params[:name],
          redirect_uri: declared_params[:redirect_uri],
          user: current_user
        )
      end

      desc 'Retrieve applications'
      route_setting :scopes, %(administrator researcher)
      get authorize: [:read, Doorkeeper::Application] do
        status 200
        present(
          Doorkeeper::Application.accessible_by(current_ability),
          with: Entities::Collection
        )
      end

      desc 'Retrieve an application by its ID'
      route_setting :scopes, %(administrator researcher)
      params do
        requires :id, type: Integer, desc: 'Application ID'
      end
      get '/:id', authorize: [:read, Doorkeeper::Application] do
        status 200
        present(
          Doorkeeper::Application.accessible_by(current_ability)
            .find(declared(params)[:id]),
          with: Entities::Application
        )
      end

      desc 'Update an application'
      route_setting :scopes, %(administrator researcher)
      params do
        requires :id, type: Integer, desc: 'Application ID'
        optional :name, type: String, desc: 'Application name'
        optional :redirect_uri,
                 type: String,
                 desc: 'OAuth redirect URI (must be HTTPS)'
      end
      post '/:id', authorize: [:write, Doorkeeper::Application] do
        status 204
        declared_params = declared(params, include_missing: false)

        app = Doorkeeper::Application.accessible_by(current_ability)
                                     .find(declared_params[:id])

        app.update_attributes(declared_hash.except(:id))
        nil
      end
    end
  end
end
