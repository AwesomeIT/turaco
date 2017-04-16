module CanStrap
  module Abilities
    class Administrator < Base
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

        # Score
        can :read, Score

        # Users
        can :read, User
        can :write, User
      end
    end
  end
end