# frozen_string_literal: true
module Events
  class PostgresProducer < Base
    module Sample
      def sample_created(model)
        respond_to :sample_speech_recognition,
                   message: model_base_message(model)
      end

      def sample_destroyed(model)
        respond_to :sample_delete_from_s3,
                   message: model_base_message(model)
                     .merge(s3_key: model.s3_key)
      end
    end
  end
end
