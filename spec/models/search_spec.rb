require 'rails_helper'

RSpec.describe Search, type: :model do
  let(:params) { { q: 'keyword', indices: ['question'] } }

  it { should validate_presence_of(:q) }

  describe 'Search#initialize' do
    it 'initialize attributes' do
      search = Search.new(params)
      expect(search.q).to eq params[:q]
      expect(search.indices).to eq params[:indices]
    end
  end

  describe 'Search.find' do
    it 'initialize search' do
      expect(Search).to receive(:new).with(params).and_call_original
      Search.find(params)
    end

    it 'validate search' do
      search = Search.new(params)
      allow(Search).to receive(:new).with(params).and_return(search)
      expect(search).to receive(:validate)
      Search.find(params)
    end

    it 'returns search' do
      expect(Search.find(params)).to be_a Search
    end
  end

  describe 'Search#results' do
    it 'call ThinkingSphinx.search' do
      search = Search.find(params)
      expect(ThinkingSphinx).to receive(:search).with(ThinkingSphinx::Query.escape(params[:q]), indices: search.indices)
      search.results
    end

    it 'return empty if query invalid' do
      search = Search.find({})
      expect(search.results).to be_empty
    end
  end
end
