shared_examples_for 'API indexable' do
  context 'authorized' do
    let(:indexable) { "#{resource.to_s}s" }
    let(:indexable_response) { json[indexable].first }
    let(:access_token) { create(:access_token) }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'returns list of resources' do
      expect(json[indexable].size).to eq resource_list.size
    end

    it 'returns all public fields' do
      public_fields.each do |attr|
        expect(indexable_response[attr]).to eq resource_list.first.send(attr).as_json
      end
    end

    it 'contains user object' do
      expect(indexable_response['user']['id']).to eq resource_list.first.user.id
    end
  end
end
