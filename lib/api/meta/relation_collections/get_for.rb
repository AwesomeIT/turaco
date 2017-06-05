# frozen_string_literal: true
module API
  module Meta
    module RelationCollections
      class GetFor
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

        # rubocop:disable Metrics/MethodLength
        # rubocop:disable Metrics/AbcSize
        def define_endpoint
          endpoint_klass.instance_exec(
            opts.merge(this_resource: this_resource)
          ) do |opts|
            get "/:id/#{opts[:relation]}",
                { authorize: opts[:authorize] }.compact do

              status 200
              return opts[:block].call if opts.key?(:block)

              data = "Kagu::Models::#{opts[:this_resource].camelize}"
                     .constantize
                     .accessible_by(current_ability)
                     .find(declared_params[:id])
                     .send(opts[:relation])
                     .unscoped

              present(data, with: Entities::Collection)
            end
          end
        end
        # rubocop:enable Metrics/MethodLength
        # rubocop:enable Metrics/AbcSize

        def desc
          @desc ||= "Get #{opts[:relation].to_s.singularize} for a given "\
                    "#{this_resource.downcase}"
        end

        def this_resource
          @this_resource ||= endpoint_klass.name.demodulize
        end
      end
    end
  end
end
