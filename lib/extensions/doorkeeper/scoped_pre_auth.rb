# frozen_string_literal: true
module Extensions
  module Doorkeeper
    class ScopedPreAuth < ::Doorkeeper::OAuth::PreAuthorization
      def initialize(server, client, attrs = {})
        @current_user = attrs[:current_user]
        super
      end

      def authorizable?
        super && user_has_scopes?
      end

      def scope
        @scope.presence || role_scopes.all
      end

      def scopes
        ::Doorkeeper::OAuth::Scopes.send(
          (scope.is_a?(Array) ? :from_array : :from_string),
          scope
        )
      end

      private

      attr_reader :current_user

      def role_scopes
        ::Doorkeeper::OAuth::Scopes
          .from_array(current_user.roles.pluck(:name).map(&:downcase))
      end

      def user_has_scopes?
        role_scopes.has_scopes?(scopes.all)
      end
    end
  end
end
