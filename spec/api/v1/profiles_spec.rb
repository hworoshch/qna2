require 'rails_helper'

describe 'profiles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  let!(:user) { create(:user) }
  let!(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:public_fields) { %w[id email created_at updated_at] }
  let(:private_fields) { %w[password encrypted_password] }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        public_fields.each do |attr|
          expect(json['user'][attr]).to eq user.send(attr).as_json
        end
      end

      it 'doesnt return private fields' do
        private_fields.each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:user_response) { json['users'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of users' do
        expect(json['users'].size).to eq 3
      end

      it 'returns all public fields' do
        public_fields.each do |attr|
          expect(user_response[attr]).to eq users.first.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        private_fields.each do |attr|
          expect(user_response).to_not have_key(attr)
        end
      end
    end
  end
end
