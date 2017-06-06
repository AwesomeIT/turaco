# frozen_string_literal: true
module API
  module Meta
    module SimpleReads
      class GetById < Meta::Base
        private

        # rubocop:disable Metrics/MethodLength
        # rubocop:disable Metrics/AbcSize
        def define_endpoint
          endpoint_klass.instance_exec(
            opts.merge(this_resource: this_resource)
          ) do |opts|
            get '/:id', { authorize: opts[:authorize] }.compact do
              status 200
              return opts[:block].call if opts.key?(:block)

              data = "Kagu::Models::#{opts[:this_resource].camelize}"
                     .constantize
                     .accessible_by(current_ability)
                     .find(declared_params[:id])

              present(
                data, with: "API::Entities::#{opts[:this_resource]}".constantize
              )
            end
          end
        end
        # rubocop:enable Metrics/MethodLength
        # rubocop:enable Metrics/AbcSize

        def desc
          @desc ||= "Get #{this_resource.downcase} by ID"
        end
      end
    end
  end
end
