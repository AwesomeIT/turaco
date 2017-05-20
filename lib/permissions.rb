# frozen_string_literal: true
module Permissions
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Administrator
    autoload :Participant
    autoload :Researcher
  end
end
