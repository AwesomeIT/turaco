# frozen_string_literal: true
module API
  module Helpers
    module Doorkeeper
      def current_user
        User.find(doorkeeper_token.try(:resource_owner_id))
      end
    end
  end
end
