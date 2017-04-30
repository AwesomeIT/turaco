# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_login_action(_resource)
    session[:previous_url] || request.referrer || root_path
  end

  # rubocop:disable Style/Alias
  alias_method :after_sign_out_path_for, :after_login_action
  alias_method :after_sign_in_path_for, :after_login_action
  # rubocop:enable Style/Alias
end
