Warhol::Config.new do |warhol|
  warhol.role_proc = proc do |user|
    user.roles.pluck(:name)
  end

  warhol.additional_accessors = %w(user)
end

Permissions.eager_load!