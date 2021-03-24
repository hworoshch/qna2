require 'rails_helper'

describe 'questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let!(:user) { create(:user) }
  let!(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let!(:valid_params) { { question: attributes_for(:question), access_token: access_token.token } }
  let!(:invalid_params) { { question: attributes_for(:question, :invalid), access_token: access_token.token } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2, user: create(:user)) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question, user: create(:user)) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body user_id created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

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

    context 'authorized' do
      let(:question_response) { json['question'] }
      let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
      let!(:links) { create_list(:link, 3, linkable: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      context 'with resources' do
        let(:resource_response) { question_response }
        let(:files) { question.files }

        it_behaves_like 'API linkable'
        it_behaves_like 'API commentable'
        it_behaves_like 'API attachable'
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { api_v1_questions_path }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      it 'creates new question with valid params' do
        expect { post api_path, params: valid_params, headers: headers }.to change(Question, :count).by(1)
      end

      it 'doesnt create the question with invalid params' do
        expect { post api_path, params: invalid_params, headers: headers }.to_not change(Question, :count)
      end
    end
  end

  describe 'PUT /api/v1/questions/:id' do
    let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API authorizable' do
      let(:method) { :put }
    end

    context 'authorized' do
      it 'updates the question with valid params' do
        put api_path, params: valid_params, headers: headers
        question.reload
        %i[title body].each do |attr|
          expect(question.send(attr)).to eq valid_params[:question][attr]
        end
      end

      it 'doesnt update the question with invalid params' do
        put api_path, params: invalid_params, headers: headers
        question.reload
        %i[title body].each do |attr|
          expect(question.send(attr)).to_not eq invalid_params[:question][attr]
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:params) { { access_token: access_token.token } }

      it 'returns 200 status' do
        delete api_path, params: params, headers: headers
        expect(response).to be_successful
      end

      it 'deletes the question' do
        expect { delete api_path, params: params, headers: headers }.to change(Question, :count).by(-1)
      end
    end
  end
end
