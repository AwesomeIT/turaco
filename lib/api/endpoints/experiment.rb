# frozen_string_literal: true
module API
  module Endpoints
    class Experiment < Grape::API
      resource :experiments
      authorize_routes!

      desc 'Record an experiment'
      route_setting :scopes, %w(administrator researcher)
      params do
        requires :name, type: String, desc: 'Name of experiment'
        requires :user_id, type: Integer, desc: 'ID of user creating experiment'
      end
      put authorize: [:write, ::Experiment] do
        status 201

        present(
          ::Experiment.create(
            declared(params).to_h
          ), with: Entities::Experiment
        )
      end

      desc 'Retrieve an experiment'
      params do
        requires :id, type: Integer, desc: 'ID of experiment'
      end
      get '/:id', authorize: [:read, ::Experiment] do
        status 200

        present(
          ::Experiment.find(declared(params)[:id]),
          with: Entities::Experiment
        )
      end

      desc 'Retrieve a list of experiments'
      params do
        optional :name, type: String, desc: 'Name of the experiment'
        optional :active, type: Boolean, desc: 'Active flag for experiments'
      end
      get authorize: [:read, ::Experiment] do
        status 200

        present(
          ::Experiment.where(declared(params).compact),
          with: Entities::Collection
        )
      end

      desc 'Delete an experiment'
      route_setting :scopes, %w(administrator researcher)
      params do
        requires :id, type: Integer, desc: 'ID of experiment'
      end
      delete '/:id', authorize: [:write, ::Experiment] do
        status 204

        ::Experiment.delete(declared(params)[:id])
      end

      desc 'Update an experiment'
      route_setting :scopes, %w(administrator researcher)
      params do
        requires :id, type: Integer, desc: 'ID of experiment to be updated'
        optional :name, type: String, desc: 'Name of the experiment'
        optional :active, type: Boolean, desc: 'Flag for experiment being used'
      end
      put '/:id', authorize: [:write, ::Experiment] do
        status 204

        present(
          ::Experiment.find(params[:id]).update(
            name: params[:name],
            active: params[:active]
          )
        )
      end
    end
  end
end
