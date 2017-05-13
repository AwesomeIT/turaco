# frozen_string_literal: true
module API
  module Entities
    class Experiment < Base
      property :id
      property :name
      property :repeats
      property :active
      property :created_at
      property :updated_at

      relation :samples

      collection :tags { property :name }
    end
  end
end
