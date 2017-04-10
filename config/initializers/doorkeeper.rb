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
end

module ScopedPreAuthExtension
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

::Doorkeeper::AuthorizationsController.prepend(ScopedPreAuthExtension)
