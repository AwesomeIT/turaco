# frozen_string_literal: true
module API
  module Endpoints
    class Score < Grape::API
      resource :scores
      authorize_routes!

      desc 'Record a score'
      route_setting :scopes, %w(participant)
      params do
        requires :experiment_id, type: Integer, desc: 'ID of experiment'
        requires :sample_id, type: Integer, desc: 'ID of sample'
        requires :rating, type: Float, desc: 'rating assigned to sample'
      end
      put authorize: [:write, ::Score] do
        status 201
        present(
          ::Score.create(
            declared(params).merge(user_id: current_user.id).to_h
          ), with: Entities::Score
        )
      end
    end
  end
end
