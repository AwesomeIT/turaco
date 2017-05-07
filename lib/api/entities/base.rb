# frozen_string_literal: true
module API
  module Entities
    class Base < Grape::Roar::Decorator
      include Roar::JSON
      include Roar::JSON::HAL
      include Roar::Hypermedia

      class << self
        def relation(rname)
          rname = rname.to_s
          case activerecord_klass.reflections[rname]
          when ActiveRecord::Reflection::BelongsToReflection
            map_single(rname)
          when ActiveRecord::Reflection::HasManyReflection,
               ActiveRecord::Reflection::HasAndBelongsToManyReflection,
               ActiveRecord::Reflection::ThroughReflection
            map_collection(rname)
          end
        end

        protected

        def activerecord_klass
          "Kagu::Models::#{name.demodulize}".safe_constantize
        end

        def decorator_for(relation)
          { embedded: true,
            extend: "API::Entities::#{relation.singularize.camelize}"
              .safe_constantize }
        end

        def map_single(rname)
          property rname, decorator_for(rname)
        end

        def map_collection(rname)
          links rname do |opts|
            request = Grape::Request.new(opts[:env])
            represented.send(rname).map do |other|
              { href: "#{request.base_url}#{request.script_name}/"\
                      "#{rname}/#{other.id}",
                id: other.id }
            end
          end
        end
      end

      def name_for_represented(represented)
        klass_name = case represented
                     when ActiveRecord::Relation
                       represented.klass.name
                     else
                       represented.class.name
                     end
        klass_name.demodulize.pluralize.downcase
      end

      link :self do |opts|
        request = Grape::Request.new(opts[:env])
        "#{request.base_url}#{request.script_name}/"\
          "#{name_for_represented(represented)}/"\
          "#{represented.try(:id)}"
      end
    end
  end
end
