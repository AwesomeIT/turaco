# frozen_string_literal: true
module API
  module Meta
    module RelationCollections
      def get_for(opts = {}, &block)
        return unless opts.present?
        this_resource = name.demodulize.underscore

        desc "Get #{opts[:relation]} for a given #{this_resource}"
        route_setting :scopes, opts[:scopes] if opts.key?(:scopes)
        params { requires :id, type: Integer, desc: "ID of #{this_resource}" }

        get "/:id/#{opts[:relation]}", { authorize: opts[:authorize] }.compact do
          status 200
          return yield if block.present?

          data = "Kagu::Models::#{this_resource.camelize}"
                 .constantize
                 .accessible_by(current_ability)
                 .find(declared_params[:id])
                 .send(opts[:relation])
                 .unscoped

          present(data, with: Entities::Collection)
        end
      end
    end
  end
end
