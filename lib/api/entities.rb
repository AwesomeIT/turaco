# frozen_string_literal: true
module API
  module Entities
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :User
    autoload :Experiment
    autoload :Sample
    autoload :Score
  end
end
