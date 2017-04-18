# frozen_string_literal: true
module CanStrap
  module Abilities
    class Researcher < Base
      define_permissions do |user|
        # Applications
        can :write, Doorkeeper::Application, user_id: user.id
        can :read, Doorkeeper::Application, user_id: user.id

        # Experiments
        can :write, Experiment, user_id: user.id
        can :read, Experiment, user_id: user.id

        # Samples
        # can :write, Sample, Sample.where(
        #   'private = false OR user_id = ?', user.id
        # )
        # can :read, Sample, Sample.where(
        #   'private = false OR user_id = ?', user.id
        # )
        can :write, Sample, Sample.where.has { (private == false) | (user_id == user.id) }
        can :read, Sample, Sample.where.has { (private == false) | (user_id == user.id) }

        # Score (tbd)
        can :read, Score

        # Users
        can :read, User, user_id: user.id
        can :write, User, user_id: user.id
      end
    end
  end
end
