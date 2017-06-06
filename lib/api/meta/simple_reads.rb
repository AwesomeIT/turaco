# frozen_string_literal: true
module API
  module Meta
    module SimpleReads
      extend ActiveSupport::Autoload
      autoload :GetById

      include Meta::Delegator
    end
  end
end
