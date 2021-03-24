shared_examples 'API commentable' do
  it 'returns list of comments' do
    expect(resource_response['comments'].size).to eq comments.count
  end

  it 'returns all public fields' do
    %w[id body user_id created_at updated_at].each do |attr|
      expect(resource_response['comments'].first[attr]).to eq comments.first.send(attr).as_json
    end
  end
end