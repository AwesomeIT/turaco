# frozen_string_literal: true
module Events
  extend ActiveSupport::Autoload

  autoload :Base

  autoload :EsManage
  autoload :PostgresSink
end
