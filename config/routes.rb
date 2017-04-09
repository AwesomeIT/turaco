# frozen_string_literal: true
Rails.application.routes.draw do
  mount API::Root => '/v3/'

  root 'doorkeeper/applications#index'

  devise_for :users
  use_doorkeeper
end
