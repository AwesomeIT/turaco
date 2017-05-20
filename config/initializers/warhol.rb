Warhol::Config.new do |warhol|
  warhol.role_proc = proc do |user|
    user.roles.pluck(:name)
  end
end

Permissions.eager_load!