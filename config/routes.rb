# frozen_string_literal: true
Rails.application.routes.draw do
  use_doorkeeper
  mount API::Root => '/v3/'
end
