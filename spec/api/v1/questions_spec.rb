require 'rails_helper'

describe 'questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let!(:user) { create(:user) }
  let!(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let!(:valid_params) { { question: attributes_for(:question), access_token: access_token.token } }
  let!(:invalid_params) { { question: attributes_for(:question, :invalid), access_token: access_token.token } }

  describe 'GET /api/v1/questions' do
    let!(:questions) { create_list(:question, 3) }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    it_behaves_like 'API indexable' do
      let(:resource) { :question }
      let(:resource_list) { questions }
      let(:public_fields) { %w[id title body created_at updated_at] }
    end

    context 'authorized' do
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question, user: create(:user)) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(15)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question, :attached_files, user: user) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    it_behaves_like 'API showable' do
      let(:resource) { question }
      let(:resource_response) { json['question'] }
      let(:public_fields) { %w[id title body created_at updated_at] }
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { api_v1_questions_path }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end

    it_behaves_like 'API creatable' do
      let(:resource) { Question }
    end
  end

  describe 'PUT /api/v1/questions/:id' do
    let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API authorizable' do
      let(:method) { :put }
    end

    it_behaves_like 'API updatable' do
      let(:resource) { question }
      let(:params_key) { :question }
      let(:resource_attr) { %i[title body] }
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'API destroyable' do
      let(:resource) { Question }
    end
  end
end
