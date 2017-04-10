# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_filter :store_location

  def after_sign_in_path_for(_resource)
    session[:previous_url] || root_path
  end
end
