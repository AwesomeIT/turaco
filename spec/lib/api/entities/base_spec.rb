# frozen_string_literal: true
require 'rails_helper'

describe API::Entities::Base, type: :request do
  let!(:score) { FactoryGirl.create(:score) }

  # Quick mockup of basic score endpoint
  before do
    class Foo < Grape::API
      format :json
      formatter :json, Grape::Formatter::Roar

      get '/scores' do
        present(Score.last, with: API::Entities::Score)
      end

      get '/samples' do 
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
    before { get '/v1/scores' }
    let(:results) { JSON.parse(response.body) }

    it 'presents the self attribute properly' do
      expect(results).to be_a(Hash)
      expect(
        results['_links']['self']['href']
      ).to eql("http://www.example.com/v1/scores/#{score.id}")
    end

    it 'provides HAL-navigable routes for embedded resources' do
      resources = %w(user experiment sample)
      expect(results['_embedded'].keys).to include(*resources)

      resources.each do |r|
        expect(results['_embedded'][r]['_links']['self']['href']).to eql(
          "http://www.example.com/v1/#{r.pluralize}/#{score.send(r).id}"
        )
      end
    end

    context 'serializing has many relationships' do 
      let(:sample) do
        FactoryGirl.create(:sample).tap do |s|
          s.tags << %w(foo bar baz)
        end
      end
      let!(:scores) { FactoryGirl.create_list(:score, 10, sample: sample)}

      before { get '/v1/samples' }

      it 'should display the correct resource URLs' do 
        resources = %w(experiments scores)
        expect(results['_links'].keys).to include(*resources)
      end
    end
  end
end
