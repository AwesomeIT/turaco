# frozen_string_literal: true
module API
  module Meta
    class Base
      def initialize(endpoint_klass, opts = {}, &block)
        @endpoint_klass = endpoint_klass
        @opts = opts
        opts[:block] = block if block.present?

        decorate
      end

      private

      attr_reader :endpoint_klass, :opts

      def decorate
        return unless opts.present?

        endpoint_klass.send(:desc, desc)
        endpoint_klass.send(
          :route_setting,
          scopes: opts[:scopes]
        ) if opts.key?(:scopes)

        define_params
        define_endpoint
      end

      def define_params
        endpoint_klass.instance_exec(this_resource) do |resource_name|
          params do
            requires :id, type: Integer, desc: "ID of #{resource_name}"
          end
        end
      end

      def define_endpoint
        raise NotImplementedError
      end

      def desc
        raise NotImplementedError
      end

      def this_resource
        @this_resource ||= endpoint_klass.name.demodulize
      end
    end
  end
end
