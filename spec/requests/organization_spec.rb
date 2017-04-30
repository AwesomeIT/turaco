require 'rails_helper'

describe 'Organization CRUD', type: :request do 
  let(:token) { FactoryGirl.create(:researcher_token) }
  let(:results) { JSON.parse(response.body) }

  context 'PUT /organizations' do
    before do
      put '/v3/organizations',
        params: { name: 'Foo Organization' },
        headers: { 'Authorization' => "Bearer #{token.token}" }
    end

    it 'should create the organization' do
      expect(response.code).to eql('201')
      expect(Organization.find(results['id'])).to be_present
    end
  end

  context 'GET /organizations' do
    let!(:organizations) do
      FactoryGirl.create_list(
        :organization, 15, users: [User.find(token.resource_owner_id)]
      ) 
    end

    let!(:not_in_orgs) { FactoryGirl.create_list(:organization, 5) }

    before do
      get '/v3/organizations', 
        headers: { 'Authorization' => "Bearer #{token.token}" }
    end

    it 'should find organizations that I am a member of' do 
      expect(response.code).to eql('200')
      ids = results['organizations'].map { |x| x['id'] }
      expect(ids).to match_array(organizations.pluck(:id))
      expect(ids).to_not match_array(not_in_orgs.pluck(:id))
    end

    context 'by ID' do
      before do
        get "/v3/organizations/#{organizations.first.id}", 
          headers: { 'Authorization' => "Bearer #{token.token}" }
      end

      it 'should find the organization' do
        expect(response.code).to eql('200')
        expect(results['id']).to eql(organizations.first.id) 
      end
    end

    context 'with tags / elasticsearch' do
      before do
        allow(::Organization).to receive(:by_tags)
          .with(tags)
          .and_return(OpenStruct.new(
            records: ::Organization.joins(:tags).where(
              tags: { name: tags.split }
            ) 
          ))

        organizations.last(5).each do |e|
          e.tags << 'foo'
        end

        get '/v3/organizations',
          params: { tags: tags }, headers: { 
            'Authorization' => "Bearer #{token.token}" 
          }
      end

      let(:tags) { 'foo bar' }

      it 'finds all the tagged records' do
        expect(response.code).to eql('200')
        expect(results['organizations'].count).to eql(5)
      end
    end
  end

  context 'POST /organizations' do
    let(:org) do
      FactoryGirl.create(:organization, users: [User.find(token.resource_owner_id)])
    end

    let(:new_name) { 'foobar' }

    before do
      post "/v3/organizations/#{org.id}",
        params: { name: new_name },
        headers: { 'Authorization' => "Bearer #{token.token}" }
    end

    it 'should update the organization name' do
      expect(response.code).to eql('200')
      org.reload
      expect(org.name).to eql(new_name)
    end
  end
end