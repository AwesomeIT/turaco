# frozen_string_literal: true
module API
  module Entities
    class Experiment < Base
      property :id
      property :name
      property :repeats
      property :active

      collection :tags, decorator: API::Entities::Tag
    end
  end
end
