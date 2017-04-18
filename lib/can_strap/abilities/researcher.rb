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

        # This is gross and I hate it
        # https://github.com/ryanb/cancan/issues/957#issuecomment-32626510
        can :write, Sample, private: false
        can :write, Sample, user_id: user.id

        can :read, Sample, private: false
        can :read, Sample, user_id: user.id

        # Score (tbd)
        can :read, Score

        # Users
        can :read, User, user_id: user.id
        can :write, User, user_id: user.id
      end
    end
  end
end
