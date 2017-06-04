require 'rails_helper'

describe API::Meta::Delegator do
  let(:host_klass) { Module.new }
  let(:host_constants) { %i(Foo Bar) }

  before do
    allow(host_klass).to receive(:constants).and_return(host_constants)
    host_constants.each do |c|
      allow(host_klass).to receive(:const_get).with(c).and_return(Class.new)
    end
    allow(host_klass).to receive(:include).and_call_original
    host_klass.include(described_class)
  end

  subject { Class.new.tap { |c| c.extend(host_klass) } }

  context 'delegator methods' do
    it 'responds to the correct methods' do
      host_constants.each do |c|
        expect(subject.respond_to?(c.to_s.underscore)).to eql(true)
      end
    end
  end
end