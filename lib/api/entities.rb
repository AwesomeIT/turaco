# frozen_string_literal: true
module API
  module Entities
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Collection
    autoload :Doorkeeper
    autoload :Experiment
    autoload :Sample
    autoload :Score
    autoload :User
  end
end
