# frozen_string_literal: true
module API
  module Endpoints
    class Score < Grape::API
      desc 'Record a score'
      params do
        requires :user_id, type: Integer, desc: 'ID of user'
        requires :experiment_id, type: Integer, desc: 'ID of experiment'
        requires :sample_id, type: Integer, desc: 'ID of sample'
        requires :rating, type: Float, desc: 'rating assigned to sample'
      end
      put do
        status 201
        present(
          ::Score.create(
            declared(params).to_h
          ), with: Entities::Score
        )
      end
    end
  end
end
