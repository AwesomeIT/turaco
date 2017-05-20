module Permissions
  class Researcher < Warhol::Ability
    define_permissions do
      # Applications
      can :write, Doorkeeper::Application, user_id: user.id
      can :read, Doorkeeper::Application, user_id: user.id

      # Experiments
      can :write, Experiment, user_id: user.id
      can :read, Experiment, user_id: user.id

      # Still relevant
      # https://github.com/ryanb/cancan/issues/957#issuecomment-32626510
      can :write, Sample, user_id: user.id
      can :read, Sample, user_id: user.id

      can :read, Organization, users: { id: user.id }
      can :write, Organization, users: { id: user.id }

      # Score (tbd)
      can :read, Score

      # Users
      can :read, User, id: user.id

      # TODO: more efficient query
      can :read, User, id: user.organizations
        .map(&:users)
        .reduce(:merge)
        &.pluck(:id)

      can :write, User, id: user.id
    end
  end
end