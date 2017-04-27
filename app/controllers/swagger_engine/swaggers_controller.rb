# frozen_string_literal: true
require_dependency 'swagger_engine/application_controller'

module SwaggerEngine
  class SwaggersController < ApplicationController
    def show
      respond_to do |format|
        format.html do
          @swagger_json_url = "#{request.base_url}/v3/swagger.json"
        end
      end
    end
  end
end
