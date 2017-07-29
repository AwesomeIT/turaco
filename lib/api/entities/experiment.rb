# frozen_string_literal: true
module API
  module Entities
    class Experiment < Base
      property :id
      property :name
      property :repeats
      property :replays
      property :active
      property :created_at
      property :updated_at
      property :user_id
      property :organization { property :id }

      relation :samples

      collection :tags { property :name }
    end
  end
end
