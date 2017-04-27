# frozen_string_literal: true
require 'doorkeeper/grape/helpers'
require 'grape-swagger'
require 'warden'

module API
  class Root < Grape::API
    helpers Doorkeeper::Grape::Helpers
    helpers ::API::Helpers::Doorkeeper
    helpers ::API::Helpers::Params

    content_type :json, 'application/json'
    content_type :multipart, 'multipart/form-data'

    default_format :json
    formatter :json, Grape::Formatter::Roar

    # TODO: Break out into its own module and handle
    # all race conditions and errors
    rescue_from ActiveRecord::RecordNotFound do |_e|
      rack_response(
        { message: 'Error!',
          description: 'Could not find requested resource' }.to_json, 404
      )
    end

    before do
      doorkeeper_authorize! unless Rails.env.test? ||
                                   request.path == '/v3/swagger.json'
    end

    mount Endpoints::Application => '/applications'
    mount Endpoints::Experiment => '/experiments'
    mount Endpoints::Sample => '/samples'
    mount Endpoints::Score => '/scores'
    mount Endpoints::User => '/users'

    add_swagger_documentation(
      mount_path: '/swagger.json',
      info: {
        title: "TalkBirdy"
      }
    )
  end
end
