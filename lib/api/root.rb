# frozen_string_literal: true
require 'warden'

module API
  class Root < Grape::API
    format :json
    formatter :json, Grape::Formatter::Roar

    helpers API::Helpers::WardenStrategies

    use Warden::Manager do |mgr|
      mgr.failure_app = ->(_env) { [401] }
    end

    # Validate API token, except for application grant
    before do
      next if request.path.match?(/^\/v3\/authorize\/app$/im)
      request = Grape::Request.new(env)

      token = request.headers.fetch('Turaco-Api-Key', nil)
      token = Doorkeeper::AccessToken.by_token(token)

      error!(
        { message: 'Error!', description: 'Application token invalid' }, 401
      ) unless token.present?
    end

    mount Endpoints::Authorize => '/authorize'
    mount Endpoints::Experiment => '/experiment'
    mount Endpoints::Sample => '/sample'
    mount Endpoints::Score => '/score'
  end
end
