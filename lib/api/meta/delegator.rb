module API
  module Meta
    module Delegator
      def self.included(other)
        other.extend(Forwardable)

        other.constants.each do |klass|
          resolved = other.const_get(klass)
          other.def_delegator(resolved, :new, klass.to_s.underscore)
        end
      end
    end
  end
end