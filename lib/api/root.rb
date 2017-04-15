# frozen_string_literal: true
require 'doorkeeper/grape/helpers'
require 'warden'

module API
  class Root < Grape::API
    helpers Doorkeeper::Grape::Helpers
    helpers ::API::Helpers::Doorkeeper

    format :json
    formatter :json, Grape::Formatter::Roar

    before do
      doorkeeper_authorize! unless Rails.env.test?
    end

    mount Endpoints::Application => '/application'
    mount Endpoints::Experiment => '/experiment'
    mount Endpoints::Sample => '/sample'
    mount Endpoints::Score => '/score'
  end
end
