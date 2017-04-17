# frozen_string_literal: true
module CanStrap
  module Abilities
    class Base
      class << self
        attr_reader :permissions

        def define_permissions(&block)
          @permissions ||= block
        end
      end
    end
  end
end
