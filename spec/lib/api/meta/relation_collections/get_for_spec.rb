require 'rails_helper'

describe API::Meta::RelationCollections::GetFor do 
  let(:endpoint_klass) { double }

  subject { described_class.new(endpoint_klass, opts) }

  context 'defining endpoints' do
    let(:opts) do 
      {
        relation: :foos,
        scopes: %w(bar baz),
        authorize: []
      }
    end

    let(:resource_name) { 'Quux' }

    after { subject }

    it 'defines the correct endpoint' do
      # Let it return some made up name
      allow(endpoint_klass).to receive_message_chain(
        :name, :demodulize
      ).and_return(resource_name)

      # Must set correct description
      expect(endpoint_klass).to receive(:desc).with(
        "Get #{opts[:relation].to_s.singularize} for a given "\
        "#{resource_name.downcase}"
      )

      # Must apply correct scopes
      expect(endpoint_klass).to receive(:route_setting).with(
        scopes: opts[:scopes]
      )

      # Must apply params, but don't know how to verify that they are 
      # the correct ones since this delegates to Grape::Validations::ParamsScope
      # and we can't really do this cleanly unless we build a string with 
      # raw Ruby and eval() it. TODO revisit this?
      expect(endpoint_klass).to receive(:params).and_return(true)

      # Must receive correct route
      expect(endpoint_klass).to receive(:get).with(
        '/:id/foos', authorize: opts[:authorize]
      ).and_return(true)
    end
  end
end