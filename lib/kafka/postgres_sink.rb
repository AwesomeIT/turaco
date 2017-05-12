module Kafka
  class PostgresSink < Base
    attr_reader :action

    %i(sample_speech_recognition es_manage).each do |t|
      topic t, required: false
    end

    def respond(action, model)
      @action = action
      action_signature = "#{model.class.name.demodulize.underscore}_#{action}"

      # If additional pipeline steps are necessary
      send(
        action_signature, model
      ) if self.class.private_method_defined?(action_signature)

      # Perform for all records and actions
      respond_to :es_manage, 
                  message: model_base_message(model)
                           .merge(action: :update_record)
    end

    private

    def sample_created(model)
      respond_to :sample_speech_recognition, 
                  message: model_base_message(model)
    end
  end
end