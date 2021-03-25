shared_examples_for 'API updatable' do
  context 'authorized' do

    it 'updates the resource with valid params' do
      put api_path, params: valid_params, headers: headers
      resource.reload
      resource_attr.each do |attr|
        expect(resource.send(attr)).to eq valid_params[params_key][attr]
      end
    end

    it 'doesnt update the resource with invalid params' do
      put api_path, params: invalid_params, headers: headers
      resource.reload
      resource_attr.each do |attr|
        expect(resource.send(attr)).to_not eq invalid_params[params_key][attr]
      end
    end
  end
end
