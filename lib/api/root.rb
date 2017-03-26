# frozen_string_literal: true
module API
  class Root < Grape::API
    format :json
    formatter :json, Grape::Formatter::Roar

    # TODO: don't be lazy when handling errors
    rescue_from :all do |err|
      error!(err, 500)
    end

    mount Endpoints::Score => '/score'
    mount Endpoints::Sample => '/sample'
    mount Endpoints::Experiment => '/experiment'
  end
end
