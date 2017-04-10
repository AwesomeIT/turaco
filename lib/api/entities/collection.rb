# frozen_string_literal: true
module API
  module Entities
    class Collection < Base
      include Roar::JSON
      include Roar::Hypermedia

      class << self
        # TODO: Find a better way to do this
        # If `representable` or `grape-roar` change their interfaces we are SOL
        # with a breaking change if our lockfile fails us.
        def represent(object, _options = {})
          serializer = clone

          serializer.extract_from_relation(
            object
          ) if object.is_a?(ActiveRecord::Relation)

          serializer.new(object)
        end

        protected

        def extract_from_relation(relation)
          str_klass = relation.klass.name.demodulize

          collection(str_klass.downcase.pluralize.to_sym,
                     extend: "API::Entities::#{str_klass}".constantize,
                     class: relation.klass)

          relation.class.send(
            :define_method,
            str_klass.downcase.pluralize,
            -> { self }
          )
        end
      end
    end
  end
end
