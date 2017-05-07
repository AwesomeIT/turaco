# frozen_string_literal: true
module API
  module Entities
    class Score < Base
      property :rating

      relation :user
      relation :experiment
      relation :sample
    end
  end
end
