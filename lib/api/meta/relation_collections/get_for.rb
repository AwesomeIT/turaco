module API
  module Meta
    module RelationCollections
      class GetFor
        def initialize(endpoint_klass)
          @endpoint_klass = endpoint_klass
        end

        # def get_for(opts = {}, &block)
        #   return unless opts.present?

        #   endpoint_klass.send(:scopes, opts[:scopes]) if opts.key?(:scopes)
        #   endpoint_klass.send(:params, &method(:get_for_params))
        #   endpoint_klass.send(
        #     :get, "/:id/#{opts[:relation]}", &method(:get_for_endpoint_body)
        #   )
        # end

        # private

        # def get_for_desc
        #   @get_for_desc ||= "Get #{opts[:relation]} for a given #{this_resource}"
        # end

        # def get_for_endpoint_body
        #   status 200
        #   # return yield if block.present?

        #   data = "Kagu::Models::#{this_resource.camelize}"
        #          .constantize
        #          .accessible_by(current_ability)
        #          .find(declared_params[:id])
        #          .send(opts[:relation])
        #          .unscoped

        #   present(data, with: Entities::Collection)
        # end

        # def get_for_params
        #   requires :id, type: Integer, desc: "ID of #{this_resource}"
        # end

        # def this_resource
        #   @this_resource ||= endpoint_klass.name.demodulize
        # end

        # attr_reader :endpoint_klass
      end
    end
  end
end