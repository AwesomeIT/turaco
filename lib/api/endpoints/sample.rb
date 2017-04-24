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
        requires :private, type: Boolean, desc: 'flag for sample sharing'
        requires :file, type: File, desc: 'audio sample, to be uploaded to s3'
        requires :low_label, type: String, desc: 'left of rating scale'
        requires :high_label, type: String, desc: 'right of rating scale'
      end
      put authorize: [:write, ::Sample] do
        status 201

        s3_url = Adapters::S3.upload_file(
          'birdfeedtemp',
          params[:file]['tempfile'].path,
          params[:file]['filename']
        )

        present(
          ::Sample.create(
            declared(params).except(:file)
                            .merge(s3_url: s3_url, user_id: current_user.id)
                            .to_h
          ), with: Entities::Sample
        )
      end

      desc 'Retrieve a sample'
      params do
        requires :id, type: Integer, desc: 'ID of sample'
      end
      get '/:id', authorize: [:read, ::Sample] do
        status 200

        present(
          ::Sample.find(declared(params)[:id]),
          with: Entities::Sample
        )
      end

      desc 'Retrieve a list of samples'
      params do
        optional :tags, type: String, desc: 'Whitespace delimited string of '\
          'tags.'
      end
      get authorize: [:read, ::Sample] do
        status 200

        predicate = if declared_params.key?(:tags)
                      ::Sample.by_tags(declared_params[:tags])
                              .records
                    else
                      ::Sample
                    end

        samples = predicate
                  .where(declared_params.except(:tags).to_h)
                  .accessible_by(current_ability)

        present(
          samples, with: Entities::Collection
        )
      end

      desc 'Delete a sample'
      route_setting :scopes, %w(administrator researcher)
      params do
        requires :id, type: Integer, desc: 'ID of sample'
      end
      delete '/:id', authorize: [:write, ::Sample] do
        status 204

        ::Sample.delete(declared(params)[:id])
      end

      desc 'Update a sample'
      route_setting :scopes, %w(administrator researcher)
      params do
        requires :id, type: Integer, desc: 'ID of sample to be updated'
        optional :name, type: String, desc: 'name of sample'
        optional :private, type: Boolean, desc: 'flag for sample sharing'
      end
      post '/:id', authorize: [:write, ::Sample] do
        status 200
        declared_params = declared(params, include_missing: false)
        sample =
          ::Sample.accessible_by(current_ability)
                  .find(declared_params[:id])
        sample.update_attributes(declared_params.to_h)
        sample.save
        present(sample, with: Entities::Sample)
      end
    end
  end
end
