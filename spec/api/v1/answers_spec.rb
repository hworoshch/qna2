require 'rails_helper'

describe 'answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let!(:user) { create(:user) }
  let!(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let!(:question) { create(:question, user: user) }
  let!(:answers) { create_list(:answer, 3, question: question, user: user) }
  let(:valid_params) { { answer: attributes_for(:answer), access_token: access_token.token } }
  let(:invalid_params) { { answer: attributes_for(:answer, :invalid), access_token: access_token.token } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    it_behaves_like 'API indexable' do
      let(:resource) { :answer }
      let(:resource_list) { answers }
      let(:public_fields) { %w[id body created_at updated_at best] }
    end

    context 'authorized' do
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

    end
  end

  describe 'GET /api/v1/questions/:question_id/answers/:id' do
    let!(:answer) { create(:answer, :attached_files, user: user, question: question) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    it_behaves_like 'API showable' do
      let(:resource) { answer }
      let(:resource_response) { json['answer'] }
      let(:public_fields) { %w[id body created_at updated_at] }
    end
  end

  describe 'POST /api/v1/answers' do
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end

    it_behaves_like 'API creatable' do
      let(:resource) { Answer }
    end
  end

  describe 'PUT /api/v1/answers/:id' do
    let!(:answer) { create(:answer, user_id: access_token.resource_owner_id, question: question) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API authorizable' do
      let(:method) { :put }
    end

    it_behaves_like 'API updatable' do
      let(:resource) { answer }
      let(:params_key) { :answer }
      let(:resource_attr) { %i[body] }
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer, user_id: access_token.resource_owner_id, question: question) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'API destroyable' do
      let(:resource) { Answer }
    end
  end
end
