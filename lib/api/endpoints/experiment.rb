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
      end
      put authorize: [:write, ::Experiment] do
        status 201

        present(
          ::Experiment.create(
            declared(params).merge(user_id: current_user.id).to_h
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
        optional :tags, type: String, desc: 'Whitespace delimited string of '\
          'tags.'
      end
      get authorize: [:read, ::Experiment] do
        status 200

        predicate = if declared_params.key?(:tags)
                      ::Experiment.by_tags(declared_params[:tags])
                                  .records
                    else
                      ::Experiment
                    end

        experiments = predicate
                      .where(declared_params.except(:tags).to_h)
                      .accessible_by(current_ability)

        present(experiments, with: Entities::Collection)
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
        optional :repeats, type: Integer, desc: 'Times a sample can be played'
      end
      post '/:id', authorize: [:write, ::Experiment] do
        status 200
        declared_params = declared(params, include_missing: false)
        experiment =
          ::Experiment.accessible_by(current_ability)
                      .find(declared_params[:id])
        experiment.update_attributes(declared_params.to_h)
        experiment.save
        present(experiment, with: Entities::Experiment)
      end
    end
  end
end
