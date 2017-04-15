# frozen_string_literal: true
module API
  module Endpoints
    class Application < Grape::API
      desc 'Create an application'
      route_setting :scopes, %(administrator)
      params do
        requires :name, type: String, desc: 'Application name'
        requires :redirect_uri,
                 type: String,
                 desc: 'OAuth redirect URI (must be HTTPS)'
      end
      put do
        status 201
        declared_params = declared(params)
        Doorkeeper::Application.create(
          name: declared_params[:name],
          redirect_uri: declared_params[:redirect_uri],
          user: current_user
        )
      end
    end
  end
end
