# frozen_string_literal: true
module API
  module Entities
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Collection
    autoload :Doorkeeper
    autoload :Experiment
    autoload :Organization
    autoload :Sample
    autoload :Score
    autoload :Tag
    autoload :User
  end
end
