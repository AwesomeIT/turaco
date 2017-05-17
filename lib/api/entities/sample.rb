# frozen_string_literal: true
module API
  module Entities
    class Sample < Base
      property :id
      property :s3_key
      property :name
      property :low_label
      property :high_label
      property :hypothesis
      property :private_url
      property :created_at
      property :updated_at
      property :user_id

      relation :experiments
      relation :scores

      collection :tags { property :name }
    end
  end
end
