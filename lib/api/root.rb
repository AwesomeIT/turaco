# frozen_string_literal: true
require 'doorkeeper/grape/helpers'
require 'warden'

module API
  class Root < Grape::API
    format :json
    formatter :json, Grape::Formatter::Roar

    mount Endpoints::Experiment => '/experiment'
    mount Endpoints::Sample => '/sample'
    mount Endpoints::Score => '/score'
  end
end
