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
        optional :active, type: Boolean, desc: 'Active flag for experiment'
        optional :repeats, type: Integer, desc: 'Times samples can be replayed'
      end
      put authorize: [:write, ::Experiment] do
        status 201

        experiment = ::Experiment.create(
          declared_hash.merge(user_id: current_user.id)
        )
        Events::PostgresSink.call(experiment)

        present(experiment, with: Entities::Experiment)
      end

      desc 'Retrieve an experiment'
      params do
        requires :id, type: Integer, desc: 'ID of experiment'
      end
      get '/:id', authorize: [:read, ::Experiment] do
        status 200

        present(
          ::Experiment.find(declared_params[:id]),
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

        experiments = Kagu::Query::Elastic.for(::Experiment).search(
          declared_hash.extract!('tags', 'name')
        ).where(declared_hash).accessible_by(current_ability)

        present(experiments, with: Entities::Collection)
      end

      desc 'Delete an experiment'
      route_setting :scopes, %w(administrator researcher)
      params do
        requires :id, type: Integer, desc: 'ID of experiment'
      end
      delete '/:id', authorize: [:write, ::Experiment] do
        status 204

        experiment = ::Experiment.find(declared_params[:id])
        Events::PostgresSink.call(experiment)
        experiment.destroy!
        
        nil
      end

      desc 'Update an experiment'
      route_setting :scopes, %w(administrator researcher)
      params do
        requires :id, type: Integer, desc: 'ID of experiment to be updated'
        optional :name, type: String, desc: 'Name of the experiment'
        optional :active, type: Boolean, desc: 'Flag for experiment being used'
        optional :repeats, type: Integer, desc: 'Times a sample can be played'
        optional :organization_id, type: Integer, desc: 'Organization ID'
        optional :sample_ids, type: Array, desc: 'Samples to associate'
      end
      post '/:id', authorize: [:write, ::Experiment] do
        status 200

        experiment =
          ::Experiment.accessible_by(current_ability)
                      .find(declared_params[:id])

        # Update regular attributes first
        experiment.update_attributes(
          declared_hash.except(:organization_id, :sample_ids)
        )

        # Append organization if present
        if declared_params.key?(:organization_id)
          experiment.organization =
            ::Organization.accessible_by(current_ability).find(
              declared_params[:organization_id]
            )
        end

        # Update samples if a list was provided
        if declared_params.key?(:sample_ids)
          experiment.samples =
            ::Sample.accessible_by(current_ability).find(
              declared_params[:sample_ids]
            )
        end

        experiment.save
        Events::PostgresSink.call(experiment)
        
        present(experiment, with: Entities::Experiment)
      end
    end
  end
end
