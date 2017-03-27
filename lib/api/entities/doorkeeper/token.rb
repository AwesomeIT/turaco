# frozen_string_literal: true
module API
  module Entities
    module Doorkeeper
      class Token < Grape::Roar::Decorator
        include Roar::JSON
        include Roar::Hypermedia

        %i(
         created_at
         expires_in
         scopes
         token
        ).each(&method(:property))
      end
    end
  end
end
