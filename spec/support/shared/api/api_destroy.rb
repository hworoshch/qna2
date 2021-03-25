shared_examples_for 'API destroyable' do
  context 'authorized' do
    let(:params) { { access_token: access_token.token } }

    it 'deletes the resource' do
      expect { delete api_path, params: params, headers: headers }.to change(resource, :count).by(-1)
    end

    it 'returns 200 status' do
      delete api_path, params: params, headers: headers
      expect(response).to be_successful
    end
  end
end