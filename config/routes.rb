# frozen_string_literal: true
Rails.application.routes.draw do
  mount API::Root => '/v3/'

  root 'doorkeeper/applications#index'


  authenticate :user do 
    use_doorkeeper
  end

  devise_for :users
  # scope '/admin' do 
  #   resources :users
  # end
end
