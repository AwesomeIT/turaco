# frozen_string_literal: true
require 'rails_helper'

describe API::Entities::Collection do
  context '.represent' do
    let!(:scores) { FactoryGirl.create_list(:score, 10) }
    let(:relation) { Score.all }

    context 'relation' do
      before { described_class.represent(relation, {}) }

      it 'should decorate the relation with itself' do 
        expect(relation).to eql(
          relation.send(relation.klass.name.demodulize.downcase.pluralize)
        )
      end
    end

    context 'only operators on ActiveRecord::Relation' do
      after { described_class.represent(double, {}) }

      it 'should exit early' do 
        expect(described_class).to_not receive(:decorate_relation)
        expect(described_class).to_not receive(:serializer_for)
      end
    end

    context 'caches relation classes' do
      let(:samples) { FactoryGirl.create_list(:sample, 5) }
      let(:other_relation) { Sample.all }

      before do
        described_class.represent(relation, {})
        described_class.represent(other_relation, {})
      end

      it 'should have cache entries for score and sample' do
        expect(described_class.send(:representer_cache).keys).to include(
          ::Sample, ::Score
        )
      end
    end
  end
end