require 'rails_helper'

describe API::Meta::Base do 
  let(:endpoint_klass) { double }

  subject { described_class.new(endpoint_klass, opts) }

  shared_examples_for 'meta_endpoint_generator' do 
    context 'defining endpoints' do
      let(:opts) do 
        { scopes: %w(bar baz),
          authorize: [] }
      end

      let(:resource_name) { 'Quux' }
      let(:desc) { double }
      let(:endpoint_def) { double }

      after { subject }

      it 'delegates to the correct methods' do
        expect_any_instance_of(described_class)
          .to receive(:desc).and_return(desc)
        expect_any_instance_of(described_class)
          .to receive(:define_endpoint).and_return(endpoint_def)
        expect_any_instance_of(described_class)
          .to receive(:decorate).and_call_original

        # Must set correct description
        expect(endpoint_klass).to receive(:desc).with(desc)

        # Let it return some made up name
        allow(endpoint_klass).to receive_message_chain(
          :name, :demodulize
        ).and_return(resource_name)

        # Must apply correct scopes
        expect(endpoint_klass).to receive(:route_setting).with(
          scopes: opts[:scopes]
        )

        # Must apply params, but don't know how to verify that they are 
        # the correct ones since this delegates to Grape::Validations::ParamsScope
        # and we can't really do this cleanly unless we build a string with 
        # raw Ruby and eval() it. TODO revisit this?
        expect(endpoint_klass).to receive(:params).and_return(true)
      end
    end
  end
end