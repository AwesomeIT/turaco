# frozen_string_literal: true
module API
  module Entities
    class Base < Grape::Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia

      # TODO: Add more declarations for different relationships,
      # namely HABTM
      def self.inherited(child)
        super(child)

        klass = "Kagu::Models::#{child.to_s.demodulize}".safe_constantize
        klass.reflections.each_pair do |name, meta|
          child.class_eval case meta
                           when ActiveRecord::Reflection::BelongsToReflection
                             "property :#{name}, "\
                               "decorator: API::Entities::#{name.camelize}"
                           when ActiveRecord::Reflection::HasManyReflection
                             "collection :#{meta.plural_name}, "\
                               "extend: API::Entities::#{name.camelize}"
                           else ''
                           end
        end if klass.present?
      end

      link :self do |opts|
        request = Grape::Request.new(opts[:env])

        "#{request.base_url}#{request.script_name}/"\
          "#{represented.class.name.demodulize.downcase}/#{represented.id}"
      end
    end
  end
end
