Rails.application.routes.draw do
  mount API::Root => '/v3/'
end
