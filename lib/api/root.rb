# frozen_string_literal: true
module API
  class Root < Grape::API
    format :json
    formatter :json, Grape::Formatter::Roar

    mount Endpoints::Score => '/score'
  end
end
