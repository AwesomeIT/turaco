Doorkeeper.configure do
  # Change the ORM that doorkeeper will use (needs plugins)
  orm :active_record

  optional_scopes :application, :administrator, :researcher, :participant
  force_ssl_in_redirect_uri Rails.env.production?

  grant_flows %w(client_credentials password)
end
