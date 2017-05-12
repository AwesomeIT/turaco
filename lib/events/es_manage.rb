# frozen_string_literal: true
module Events
  class EsManage < Base
    attr_reader :action

    topic :es_manage, required: false
    def respond(action)
      respond_to :es_manage, message: { action: action }
    end
  end
end
