shared_examples 'API attachable' do
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
