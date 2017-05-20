# frozen_string_literal: true
module Permissions
  class Administrator < Warhol::Ability
    define_permissions do
      # Applications
      can :write, Doorkeeper::Application
      can :read, Doorkeeper::Application

      # Experiments
      can :write, Experiment
      can :read, Experiment

      # Samples
      can :write, Sample
      can :read, Sample

      # Organizations
      can :write, Organization
      can :read, Organization

      # Score
      can :read, Score

      # Users
      can :read, ::User
      can :write, ::User
    end
  end
end
