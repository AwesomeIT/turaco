# frozen_string_literal: true
module API
  module Entities
    class Experiment < Base
      property :id
      property :name
      property :repeats
      property :active
    end
  end
end
