# frozen_string_literal: true
module API
  module Endpoints
    class Sample < Grape::API
      resource :samples
      authorize_routes!

      desc 'Record a sample'
      route_setting :scopes, %w(administrator researcher)
      params do
        requires :name, type: String, desc: 'name of sample'
        requires :file, type: File,
                        desc: 'audio sample, to be uploaded to s3'
        requires :low_label, type: String, desc: 'Label for low bound'
        requires :high_label, type: String, desc: 'Label for upper bound'
      end
      put authorize: [:write, ::Sample] do
        status 201

        s3_object = Kagu::Adapters::S3.upload_file(
          params[:file]['tempfile'].path,
          params[:file]['filename']
        )

        sample = ::Sample.create(declared_hash.except(:file).merge(
            s3_key: s3_object.key, user_id: current_user.id
          )
        )

        Events::PostgresSink.call(sample, :created)
        present(sample, with: Entities::Sample)
      end

      desc 'Retrieve a sample'
      params do
        requires :id, type: Integer, desc: 'ID of sample'
      end
      get '/:id', authorize: [:read, ::Sample] do
        status 200
        present(::Sample.find(declared_params[:id]), with: Entities::Sample)
      end

      desc 'Retrieve a list of samples'
      params do
        optional :tags, type: String, desc: 'Whitespace delimited string of '\
          'tags.'
      end
      get authorize: [:read, ::Sample] do
        status 200

        samples = Kagu::Query::Elastic.for(::Sample).search(
          declared_hash.extract!('tags', 'name')
        ).where(declared_hash).accessible_by(current_ability)

        present(samples, with: Entities::Collection)
      end

      desc 'Delete a sample'
      route_setting :scopes, %w(administrator researcher)
      params do
        requires :id, type: Integer, desc: 'ID of sample'
      end
      delete '/:id', authorize: [:write, ::Sample] do
        status 204

        sample = ::Sample.find(declared_params[:id])
        Events::PostgresSink.call(sample)
        sample.destroy!

        nil
      end

      desc 'Update a sample'
      route_setting :scopes, %w(administrator researcher)
      params do
        requires :id, type: Integer, desc: 'ID of sample to be updated'
        optional :name, type: String, desc: 'Name of sample'
      end
      post '/:id', authorize: [:write, ::Sample] do
        status 200

        sample = ::Sample.accessible_by(current_ability)
                         .find(declared_params[:id])

        sample.update_attributes(declared_hash)
        Events::PostgresSink.call(sample)

        present(sample, with: Entities::Sample)
      end

      desc 'Associate a sample with an organization'
      route_setting :scopes, %w(administrator researcher)
      params do
        requires :id, type: Integer, desc: 'Sample ID'
        requires :organization_id, type: Integer, desc: 'Organization ID'
      end
      put '/:id/organizations/:organization_id' do
        status 201

        # Cannot use DSL for this since we need to do both
        authorize! :write, ::Sample
        authorize! :write, ::Organization

        sample = ::Sample.accessible_by(current_ability)
                         .find(declared_params[:id])
        organization = ::Organization.accessible_by(current_ability)
                                     .find(declared_params[:organization_id])

        sample.organizations << organization

        nil
      end

      desc 'Disassociate a sample with an organization'
      route_setting :scopes, %w(administrator researcher)
      params do
        requires :id, type: Integer, desc: 'Sample ID'
        requires :organization_id, type: Integer, desc: 'Organization ID'
      end
      delete '/:id/organizations/:organization_id' do
        status 204

        authorize! :write, ::Sample
        authorize! :write, ::Organization

        sample = ::Sample.accessible_by(current_ability)
                         .find(declared_params[:id])
        organization = ::Organization.accessible_by(current_ability)
                                     .find(declared_params[:organization_id])

        sample.organizations.delete(organization)

        nil
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
