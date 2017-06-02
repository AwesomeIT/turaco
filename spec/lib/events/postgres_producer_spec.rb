# frozen_string_literal: true
require 'rails_helper'

describe Events::PostgresProducer do
  context '#respond' do
    let(:model) { FactoryGirl.create(:experiment) }

    context 'defaults' do
      after { subject.respond(model) }

      it 'invokes the correct methods' do 
        expect(described_class).to receive(:method_defined?)
          .with("#{model.class.name.demodulize.underscore}_changed")
          .and_call_original

        allow(described_class).to receive(:method_defined?)
          .with(:update_elasticsearch)

        expect(subject).to receive(:update_elasticsearch).and_return(true)
      end
    end

    context 'invokes the correct pipeline step, if present' do
      let(:action) { :deleted }
      let(:model_action) do
        "#{model.class.name.demodulize.underscore}_#{action.to_s}"
      end

      it 'correctly checks for the action' do
        expect(described_class).to receive(:method_defined?)
          .with(model_action)
          .and_return(true)

        expect { subject.respond(model, action) }.to raise_error NoMethodError
      end

      context 'when the method is actually there' do
        let(:model) { double }

        before do
          expect(model).to receive(:id).and_return(1)
          allow(model)
            .to receive_message_chain(*%i(class name demodulize underscore))
            .and_return('foo')

          described_class.include(Module.new do
            def foo_deleted(_); end
          end)
        end

        after { subject.respond(model, action) }

        it 'will call foo_deleted' do
          expect(described_class).to receive(:method_defined?)
            .with(model_action)
            .and_call_original

          expect(subject).to receive(:foo_deleted)
        end
      end
    end
  end
end