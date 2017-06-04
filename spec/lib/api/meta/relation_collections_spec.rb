require 'rails_helper'

describe API::Meta::RelationCollections do
  let(:endpoint_klass) { double }

  after do
    endpoint_klass.extend(described_class)
    endpoint_klass.get_for(opts)
  end

  context '.get_for' do
    let(:current_endpoint_name) { 'foo' }

    let(:relation) { :experiments }
    let(:opts) { { relation: relation } }

    it 'attempts to create the correct endpoint' do
      expect(endpoint_klass).to receive_message_chain(
        :name, :demodulize, :underscore
      ).and_return(current_endpoint_name)

      expect(endpoint_klass).to receive(:desc).with(
        "Get #{relation} for a given #{current_endpoint_name.singularize}"
      )

      expect(endpoint_klass).to receive(:params).and_return(true)

      expect(endpoint_klass).to receive(:get)
        .with("/:id/experiments", {}).and_return(true)
    end
  end
end