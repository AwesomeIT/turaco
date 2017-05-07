# frozen_string_literal: true
module API
  module Endpoints
    class Organization < Grape::API
      resource :organizations
      authorize_routes!

      desc 'Create an organization'
      route_setting :scopes, %w(administrator researcher)
      params do
        requires :name, type: String, desc: 'Name of organization',
                        documentation: { param_type: 'body' }
      end
      put do
        status 201

        new_org = ::Organization.create(declared_hash)
        new_org.users << current_user
        new_org.save

        present(new_org, with: Entities::Organization)
      end

      desc 'List organizations'
      route_setting :scopes, %w(administrator researcher participant)
      params do
        optional :name, type: String, desc: 'Name of the organization'
        optional :tags, type: String, desc: 'Whitespace delimited string of '\
          'tags.'
      end
      get authorize: [:read, ::Organization] do
        status 200

        organizations = Kagu::Query::Elastic.for(::Organization).search(
          declared_hash.extract!(*%w(tags name))
        ).where(declared_hash).accessible_by(current_ability)

        present(organizations, with: Entities::Collection)
      end

      desc 'Retrieve an organization by ID'
      route_setting :scopes, %w(administrator researcher participant)
      params do
        requires :id, type: String, desc: 'ID of organization'
      end
      get '/:id', authorize: [:write, ::Organization] do
        status 200

        present(::Organization.accessible_by(current_ability).find(
                  declared_params[:id]
        ), with: Entities::Organization)
      end

      desc 'Update an organization'
      route_setting :scopes, %w(administrator researcher)
      params do
        requires :id, type: String, desc: 'ID of organization'
        optional :name, type: String, desc: 'Name of organization',
                        documentation: { param_type: 'body' }
      end
      post '/:id', authorize: [:write, ::Organization] do
        status 200

        org = ::Organization.accessible_by(current_ability)
                            .find(declared_params[:id])
        org.update_attributes(declared_hash)
        org.save

        present(org, with: Entities::Organization)
      end
    end
  end
end
