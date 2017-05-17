# frozen_string_literal: true
module API
  module Entities
    class Organization < Base
      property :id
      property :name

      relation :users
      relation :experiments
      relation :samples

      relation :users
    end
  end
end
