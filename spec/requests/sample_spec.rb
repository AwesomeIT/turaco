require 'rails_helper'

describe 'Sample CRUD', type: :request do 
  let(:user) { FactoryGirl.create(:user) }
  let(:attachment) { Rack::Test::UploadedFile.new(
    "./spec/support/sample.wav", "audio/wav") }
  
  context 'PUT /sample' do 
    before do
      put '/v3/sample', 
        user_id: user.id,
        name: 'name',
        private: false,
        file: attachment,
        low_label: 'not R',
        high_label: 'R'
    end

    let(:result) { JSON.parse(response.body) }

    it 'should create a sample' do 
      expect(response.code).to eql('201')
    end

    context 'with invalid/missing parameters' do 
      before do
        put '/v3/sample', 
          user_id: user.id
      end
      it 'should enforce required' do 
        expect(response.code).to eql('400')
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end
end