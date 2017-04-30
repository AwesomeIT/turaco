# frozen_string_literal: true
module Adapters
  class S3
    include Singleton

    def self.upload_file(bucket = ENV['AWS_S3_BUCKET_NAME'], path, file_name)
      obj = instance.resource.bucket(bucket).object(file_name)
      obj.upload_file(path)
      obj.public_url
    end

    def resource
      @resource ||= Aws::S3::Resource.new(
        credentials: Aws::Credentials.new(
          ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']
        ),
        region: 'us-east-1'
      )
    end
  end
end
