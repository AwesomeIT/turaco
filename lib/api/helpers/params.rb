# frozen_string_literal: true
module API
  module Helpers
    module Params
      def declared_params
        declared(params, include_missing: false)
      end

      def declared_hash
        @declared_hash ||= declared_params.to_h
      end
    end
  end
end
