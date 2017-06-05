# frozen_string_literal: true
module API
  module Meta
    module Delegator
      def self.included(other)
        other.constants.each do |klass|
          resolved = other.const_get(klass)
          other.send(
            :define_method,
            klass.to_s.underscore,
            proc { |*args, &block| resolved.new(self, *args, &block) }
          )
        end
      end
    end
  end
end
