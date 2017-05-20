# frozen_string_literal: true
module Permissions
  class Participant < Warhol::Ability
    define_permissions do
      # Experiments
      can :read, Experiment

      # Samples
      can :read, Sample

      # Can submit scores
      can :read, Score
      can :write, Score

      # Users
      can :read, User, user_id: user.id
      can :write, User, user_id: user.id
    end
  end
end
