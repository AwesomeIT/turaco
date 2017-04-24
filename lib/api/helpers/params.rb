# frozen_string_literal: true
module API
  module Helpers
    module Params
      def declared_params
        declared(params, include_missing: false)
      end
    end
  end
end
