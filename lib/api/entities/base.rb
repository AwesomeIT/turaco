# frozen_string_literal: true
module API
  module Entities
    class Base < Grape::Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia

      class << self
        def inherited(child)
          super(child)

          klass = "Kagu::Models::#{child.to_s.demodulize}".safe_constantize
          return unless klass.present?

          klass.reflections
               .each_pair { |n, m| child.class_eval(generate_eval(n, m).to_s) }
        end

        private

        def generate_eval(name, meta)
          case meta
          when ActiveRecord::Reflection::BelongsToReflection
            "property :#{name.singularize}, "\
              "decorator: API::Entities::#{name.camelize}"
          when ActiveRecord::Reflection::HasManyReflection,
              ActiveRecord::Reflection::HasAndBelongsToManyReflection
            "collection :#{meta.plural_name}, "\
              'decorator: API::Entities::Collection'
          else ''
          end
        end
      end

      link :self do |opts|
        request = Grape::Request.new(opts[:env])
        "#{request.base_url}#{request.script_name}/"\
          "#{represented.class.name.demodulize.downcase}/"\
          "#{represented.try(:id)}"
      end
    end
  end
end
