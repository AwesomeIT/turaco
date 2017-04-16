# frozen_string_literal: true
module API
  module Entities
    class Application < Base
      %i(
        id
        name
        uid
        secret
        redirect_uri
      ).each(&method(:property))
    end
  end
end
