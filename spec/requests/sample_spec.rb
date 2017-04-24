require 'rails_helper'

describe 'Sample CRUD', type: :request do 
  let(:user) { FactoryGirl.create(:researcher_user) }
  let(:attachment) { Rack::Test::UploadedFile.new(
    "./spec/support/sample.wav", "audio/wav") }

  let(:token) { FactoryGirl.create(:oauth_token, resource_owner_id: user.id) }

  let(:result) { JSON.parse(response.body) }
  
  context 'PUT /samples' do 
    before do
      allow(Adapters::S3).to receive(:upload_file).and_return(true)
      put '/v3/samples', 
      params: {
        name: 'name',
        private: false,
        file: attachment,
        low_label: 'not R',
        high_label: 'R'
      }, 
      headers: { 'Authorization' => "Bearer #{token.token}" }
    end

    it 'should create a sample' do 
      expect(Adapters::S3)
        .to have_received(:upload_file)
        .with(
          'birdfeedtemp', instance_of(String),attachment.original_filename
        )
      expect(response.code).to eql('201')
    end

    context 'with invalid/missing parameters' do 
      before do
        put '/v3/samples', params: { user_id: user.id }, headers: { 
          'Authorization' => "Bearer #{token.token}" 
        }
      end

      it 'should enforce required' do 
        expect(response.code).to eql('400')
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end

  context 'GET /samples' do
    let!(:samples) do
      FactoryGirl.create_list(:sample, 15, user_id: token.resource_owner_id)
    end

    context 'get single sample' do
      before do
        get "/v3/samples/#{samples.first.id}", 
          headers: { 'Authorization' => "Bearer #{token.token}" }
      end

      let!(:result) { JSON.parse(response.body) }

      it 'should retrieve an existing sample' do
        expect(response.code).to eql('200')
      end
    end

    context 'tags / with elasticsearch' do
      # Don't require ES in test, just ensure it happens
      before do
        allow(::Sample).to receive(:by_tags)
          .with(tags)
          .and_return(OpenStruct.new(
            records: ::Sample.joins(:tags).where(
              tags: { name: tags.split }
            ) 
          ))

        samples.last(5).each do |s|
          s.tags << 'foo'
        end

        get '/v3/samples',
          params: { tags: tags }, headers: { 
            'Authorization' => "Bearer #{token.token}" 
          }
      end

      let(:tags) { 'foo bar' }

      it 'finds all the tagged records' do
        expect(response.code).to eql('200')
        expect(result['samples'].count).to eql(5)
      end
    end

    context 'get all samples' do
      before do
        get '/v3/samples/',
          headers: { 'Authorization' => "Bearer #{token.token}" }
      end

      it 'should get all samples' do
        expect(result["samples"].count).to eql(15)
        expect(response.code).to eql('200')
      end
    end
  end

  context 'DELETE /samples' do
    let!(:sample) { FactoryGirl.create(:sample) }

    context 'delete a sample' do
      before do
        delete "/v3/samples/#{sample.id}",
          headers: { 'Authorization' => "Bearer #{token.token}" }
      end

      it 'should have deleted the sample' do
        expect(response.code).to eql('204')
        expect(::Sample.exists?(sample.id)).to eql(false)
      end
    end
  end

  context 'UPDATE /samples' do
    let!(:sample) { FactoryGirl.create(:sample, user_id: token.resource_owner_id) }

    context 'update a sample' do
      before do
        post "/v3/samples/#{sample.id}",
        params: {
          user_id: user.id,
          name: 'new_name'
        },
        headers: { 'Authorization' => "Bearer #{token.token}" }
      end

      it 'should have updated the sample' do
        expect(response.code).to eql('200')
        expect(::Sample.find(sample.id).name).to eql('new_name')
      end
    end
  end
end