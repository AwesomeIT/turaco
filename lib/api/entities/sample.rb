# frozen_string_literal: true
module API
  module Entities
    class Sample < Base
      property :id
      property :s3_url
      property :name
      property :low_label
      property :high_label
      property :hypothesis

      collection :tags, decorator: API::Entities::Tag
    end
  end
end
