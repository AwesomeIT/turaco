require 'rails_helper'

describe 'Experiment CRUD', type: :request do 
  
  let!(:user) { FactoryGirl.create(:researcher_user) }
  let(:token) { FactoryGirl.create(:oauth_token, resource_owner_id: user.id) }

  let(:results) { JSON.parse(response.body) }

  context 'PUT /experiments' do 
    before do
      put '/v3/experiments',
      params: { 
        name: 'name'
      },
      headers: { 'Authorization' => "Bearer #{token.token}" }
    end
    let(:result) { JSON.parse(response.body) }

    it 'should create an experiment' do 
      expect(response.code).to eql('201')
    end
  end

  context 'DELETE /experiments' do
    let!(:experiment) { FactoryGirl.create(:experiment) }

    context 'delete an experiment' do
      before do
        delete "/v3/experiments/#{experiment.id}",
          headers: { 'Authorization' => "Bearer #{token.token}" }
      end

      let!(:result) { JSON.parse(response.body) }

      it 'should have deleted the experiment' do
        expect(response.code).to eql('204')
        expect(::Experiment.exists?(experiment.id)).to eql(false)
      end
    end
  end

  context 'UPDATE /experiments' do
    let! (:experiment) { FactoryGirl.create(:experiment, user_id: token.resource_owner_id) }

    context 'update an experiment' do
      before do
        post "/v3/experiments/#{experiment.id}",
        params: {
          name: 'new_name'
        },
        headers: { 'Authorization' => "Bearer #{token.token}" }
      end

      let!(:result) { JSON.parse(response.body) }

      it 'should have updated the experiment' do
        expect(response.code).to eql('200')
        expect(::Experiment.find(experiment.id).name).to eql('new_name')
      end
    end
  end

  context 'GET /experiments' do 
    let!(:experiments) do
      FactoryGirl.create_list(:experiment, 25, user_id: token.resource_owner_id)
    end

    context 'get single experiment' do
      before do
        get "/v3/experiments/#{experiments.first.id}",
          headers: { 'Authorization' => "Bearer #{token.token}" }
      end

      let!(:result) { JSON.parse(response.body) }

      it 'should retrieve an existing experiment' do
        expect(response.code).to eql('200')
      end

      it 'should get the properties of the experiment' do
        expect(result['name']).to eql (experiments.first.name)
      end
    end

    context 'with no filters' do
      before do 
        get '/v3/experiments',
          headers: { 'Authorization' => "Bearer #{token.token}" }
      end

      it 'should return all the experiments' do
        expect(results['experiments'].count).to eql(25)
        expect(response.code).to eql('200')
      end
    end

    context 'with tags / elasticsearch' do
      # Don't require ES in test, just ensure it happens
      before do
        allow(::Experiment).to receive(:by_tags)
          .with(tags)
          .and_return(OpenStruct.new(
            records: ::Experiment.joins(:tags).where(
              tags: { name: tags.split }
            ) 
          ))

        experiments.last(5).each do |e|
          e.tags << 'foo'
        end

        get '/v3/experiments',
          params: { tags: tags }, headers: { 
            'Authorization' => "Bearer #{token.token}" 
          }
      end

      let(:tags) { 'foo bar' }

      it 'finds all the tagged records' do
        expect(response.code).to eql('200')
        expect(results['experiments'].count).to eql(5)
      end
    end

    context 'with querystring filters' do 
      before do
        experiments.last.name = 'foobar'
        experiments.last.save

        get '/v3/experiments', params: { name: 'foobar' }, headers: { 
          'Authorization' => "Bearer #{token.token}" 
        }
      end

      it 'should return the correct experiments' do 
        expect(response.code).to eql('200')
        expect(results['experiments'].first['links'].first['href'])
        .to eql("http://www.example.com/v3/experiment/#{experiments.last.id}")
      end
    end
  end
end
