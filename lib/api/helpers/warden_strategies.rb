module API
  module Helpers
    module WardenStrategies
      Warden::Strategies.add(:user_grant) do
        def authenticate!
          user = User.find_by(email: params['email'])
          return fail!(:not_found) unless user.present?


          if user.valid_password?(params['password'])
            success!(Doorkeeper::AccessToken.create(resource_owner_id: user.id))
          else
            return fail!(:unsuccessful_login)
          end
        end
      end
    end
  end
end