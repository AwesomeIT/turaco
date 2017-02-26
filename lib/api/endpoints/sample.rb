# frozen_string_literal: true
module API
  module Endpoints
    class Sample < Grape::API
      desc 'Record a sample'
      params do
        requires :user_id, type: Integer, desc: 'ID of user'
        requires :name, type: String, desc: 'name of sample'
        requires :private, type: Boolean, desc: 'flag for sample sharing'
        requires :file, type: File, desc: 'audio sample, to be uploaded to s3'
        requires :low_label, type: String, desc: 'left of rating scale'
        requires :high_label, type: String, desc: 'right of rating scale'
      end
      put do
        status 201

        s3_url = Adapters::S3.upload_file(
          'birdfeedtemp', params[:file]['tempfile'], params[:file]['filename']
        )

        present(
          ::Sample.create(
            declared(params).except(:file).merge(s3_url: s3_url) .to_h
          ), with: Entities::Sample
        )
      end
    end
  end
end
