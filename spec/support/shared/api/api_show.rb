shared_examples_for 'API showable' do
  context 'authorized' do
    let!(:comments) { create_list(:comment, 3, commentable: resource, user: user) }
    let!(:links) { create_list(:link, 3, linkable: resource) }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'returns all public fields' do
      public_fields.each do |attr|
        expect(resource_response[attr]).to eq resource.send(attr).as_json
      end
    end

    context 'with links' do
      it 'returns list of links' do
        expect(resource_response['links'].size).to eq links.count
      end

      it 'returns all public fields' do
        %w[id name url created_at updated_at].each do |attr|
          expect(resource_response['links'].first[attr]).to eq links.first.send(attr).as_json
        end
      end
    end

    context 'with comments' do
      it 'returns list of comments' do
        expect(resource_response['comments'].size).to eq comments.count
      end

      it 'returns all public fields' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(resource_response['comments'].first[attr]).to eq comments.first.send(attr).as_json
        end
      end
    end

    context 'with files' do
      let(:files) { resource.files }
      let(:file_response) { resource_response['files'].first }
      let(:file) { files.first }

      it 'returns list of files' do
        expect(resource_response['files'].count).to eq files.count
      end

      it 'returns id' do
        expect(file_response['id']).to eq file.id
      end

      it 'returns filename' do
        expect(file_response['file_name']).to eq file.filename.to_s
      end

      it 'returns path' do
        expect(file_response['path']).to eq rails_blob_path(file, disposition: 'attachment', only_path: true)
      end
    end
  end
end
