# frozen_string_literal: true
module Events
  class PostgresSink < Base
    attr_reader :action, :model

    %i(sample_delete_from_s3 sample_speech_recognition es_manage).each do |t|
      topic t, required: false
    end

    def respond(model, action = :changed)
      @action = action
      @model = model

      action_signature = "#{model.class.name.demodulize.underscore}_#{action}"

      # If additional pipeline steps are necessary
      send(
        action_signature, model
      ) if self.class.private_method_defined?(action_signature)

      # For all records
      update_elasticsearch
    end

    private

    def update_elasticsearch
      es_mapped_action = case action
                         when :destroyed then :destroy_record
                         else :update_record
                         end

      respond_to :es_manage, message: model_base_message(model).merge(
        action: es_mapped_action
      )
    end

    def sample_created(model)
      respond_to :sample_speech_recognition,
                 message: model_base_message(model)
    end

    def sample_destroyed(model)
      respond_to :sample_delete_from_s3,
                 message: model_base_message(model).merge(s3_key: model.s3_key)
    end
  end
end
