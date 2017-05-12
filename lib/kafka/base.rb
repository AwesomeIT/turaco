module Kafka
  class Base < Karafka::BaseResponder
    include Singleton

    class << self
      extend Forwardable
      def_delegator :instance, :call
    end

    def call(*data)
      respond(*data)
      validate!
      deliver!
    end

    def respond(*args)
      raise NotImplementedError
    end

    private

    def model_base_message(model)
      @model_base_message ||= {
        type: model.class.name,
        id: model.id
      }
    end
  end
end