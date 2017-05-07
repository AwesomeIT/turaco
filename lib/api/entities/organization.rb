# frozen_string_literal: true
module API
  module Entities
    class Organization < Base
      property :id
      property :name

      relation :users
      relation :experiments
      relation :samples

      collection :tags { property :name }
    end
  end
end
