Doorkeeper.configure do
  # Change the ORM that doorkeeper will use (needs plugins)
  orm :active_record

  # Disable the OAuth admin panel
  admin_authenticator do 
    redirect_to(new_user_session_url) unless Rails.env.development?
  end

  # Use Devise for current_user
  resource_owner_authenticator do
    session[:previous_url] = request.fullpath
    current_user || redirect_to(new_user_session_url)
  end

  optional_scopes :administrator, :researcher, :participant
  force_ssl_in_redirect_uri Rails.env.production?

  # Only grant for OAuth
  grant_flows %w(authorization_code)

  # Patch additional relationship into model
  class Doorkeeper::Application < ActiveRecord::Base
    belongs_to :user, class_name: ::User
  end 

  # Access token behavior uses refresh tokens and 
  # expires access tokens every two hours
  access_token_expires_in 2.hours
  use_refresh_token
end