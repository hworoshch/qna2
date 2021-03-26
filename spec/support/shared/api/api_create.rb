shared_examples_for 'API creatable' do
  context 'authorized' do
    it 'creates new resource with valid params' do
      expect { post api_path, params: valid_params, headers: headers }.to change(resource, :count).by(1)
    end

    it 'doesnt create the resource with invalid params' do
      expect { post api_path, params: invalid_params, headers: headers }.to_not change(resource, :count)
    end
  end
end
