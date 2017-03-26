# frozen_string_literal: true
require 'rails_helper'

describe API::Entities::Base, type: :request do
  let!(:score) { FactoryGirl.create(:score) }

  # Quick mockup of basic score endpoint
  before do
    class Foo < Grape::API
      format :json
      formatter :json, Grape::Formatter::Roar

      get '/score' do
        present(Score.last, with: API::Entities::Score)
      end

      get '/sample' do 
        present(Sample.last, with: API::Entities::Sample)
      end
    end

    Rails.application.routes.draw do
      mount Foo => '/v1'
    end
  end

  # Don't pollute the routes across tests
  after { Rails.application.reload_routes! }

  context 'HAL' do
    before { get '/v1/score' }
    let(:results) { JSON.parse(response.body) }

    it 'presents the self attribute properly' do
      expect(results).to be_a(Hash)
      expect(results['links'].map { |l| l['rel'] }).to include('self')
      expect(
        results['links'].find { |l| l['rel'] == 'self' }['href']
      ).to eql("http://www.example.com/v1/score/#{score.id}")
    end

    it 'provides HAL-navigable routes for resources' do
      resources = %w(user experiment sample)
      expect(results.keys).to include(*resources)

      resources.each do |r|
        expect(results[r]['links'].first['href']).to eql(
          "http://www.example.com/v1/#{r}/#{score.send(r).id}"
        )
      end
    end

    context 'serializing has many relationships' do 
      let(:sample) { FactoryGirl.create(:sample) }
      let!(:scores) { FactoryGirl.create_list(:score, 10, sample: sample)}

      before { get '/v1/sample' }

      it 'should display the correct resource URLs' do 
        resources = %w(experiments scores)
        expect(results.keys).to include(*resources)
      end
    end
  end
end
