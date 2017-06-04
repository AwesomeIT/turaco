# frozen_string_literal: true
module API
  module Meta
    module RelationCollections
      extend ActiveSupport::Autoload
      autoload :GetFor
      
      include Meta::Delegator
    end
  end
end
