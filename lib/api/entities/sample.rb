# frozen_string_literal: true
module API
  module Entities
    class Sample < Base
      property :s3_url
      property :name
      property :low_label
      property :high_label
      property :private
      property :hypothesis

      # TODO: Add tags property
    end
  end
end
