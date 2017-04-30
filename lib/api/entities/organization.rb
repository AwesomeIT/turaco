# frozen_string_literal: true
module API
  module Entities
    class Organization < Base
      property :id
      property :name

      collection :tags, decorator: API::Entities::Tag
    end
  end
end
