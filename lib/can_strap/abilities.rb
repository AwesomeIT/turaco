# frozen_string_literal: true
module CanStrap
  module Abilities
    extend ActiveSupport::Autoload

    autoload :Base

    autoload :Administrator
    autoload :Researcher
  end
end
