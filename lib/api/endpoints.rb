# frozen_string_literal: true
module API
  module Endpoints
    extend ActiveSupport::Autoload

    autoload :Authorize
    autoload :Experiment
    autoload :Organization
    autoload :Sample
    autoload :Score
    autoload :User
  end
end
