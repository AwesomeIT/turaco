# frozen_string_literal: true
module Doorkeeper
  class CustomAuthorizationsController < Doorkeeper::AuthorizationsController
    #
    # We associate scopes with permissions levels stored in
    # our database. This is a custom subclass of
    # Doorkeeper::OAuth::PreAuthentication with logic to ensure that
    # users cannot violate their role levels.
    #
    # @return Extensions::Doorkeeper::ScopedPreAuth
    def pre_auth
      @pre_auth ||= begin
        params[:current_user] = current_user
        Extensions::Doorkeeper::ScopedPreAuth.new(
          Doorkeeper.configuration,
          server.client_via_uid,
          params
        )
      end
    end
  end
end
