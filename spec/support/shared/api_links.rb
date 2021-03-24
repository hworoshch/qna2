shared_examples 'API linkable' do
  it 'returns list of links' do
    expect(resource_response['links'].size).to eq links.count
  end

  it 'returns all public fields' do
    %w[id name url created_at updated_at].each do |attr|
      expect(resource_response['links'].first[attr]).to eq links.first.send(attr).as_json
    end
  end
end
