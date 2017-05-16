# frozen_string_literal: true
module API
  module Entities
    class Collection < Base
      class << self
        def represent(object, _options = {})
          return super unless object.class < ActiveRecord::Relation
          decorate_relation(object)
          serializer_for(object)
        end

        protected

        def create_serializer(klass)
          representer_cache[klass] = Class.new(Base)
          representer_cache[klass].class_exec(klass.name) do |kn|
            collection(
              kn.demodulize.downcase.pluralize.to_sym,
              extend: "API::Entities::#{kn.demodulize}".constantize
            )
          end
        end

        def decorate_relation(relation)
          relation.class.send(
            :define_method,
            relation.klass.name.demodulize.downcase.pluralize,
            -> { self }
          )
        end

        def representer_cache
          @representer_cache ||= {}
        end

        def serializer_for(object)
          klass = object.klass
          return representer_cache[klass]
                 .new(object) if representer_cache.key?(klass)

          create_serializer(klass)
          representer_cache[klass].new(object)
        end
      end
    end
  end
end
