require 'rails_helper'

describe 'answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let!(:user) { create(:user) }
  let!(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let!(:question) { create(:question, user: user) }
  let(:valid_params) { { answer: attributes_for(:answer), access_token: access_token.token } }
  let(:invalid_params) { { answer: attributes_for(:answer, :invalid), access_token: access_token.token } }

  describe 'GET /api/v1/questions/:question_id/answers' do
     let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 3, question: question, user: create(:user)) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at best].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq answer.user.id
      end
    end
  end

  describe 'GET /api/v1/questions/:question_id/answers/:id' do
    let!(:answer) { create(:answer, :attached_files, user: user, question: question) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_response) { json['answer'] }
      let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
      let!(:links) { create_list(:link, 3, linkable: answer) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      context 'with resources' do
        let(:resource_response) { answer_response }
        let(:files) { answer.files }

        it_behaves_like 'API commentable'
        it_behaves_like 'API linkable'
        it_behaves_like 'API attachable'
      end
    end
  end

  describe 'POST /api/v1/answers' do
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      it 'creates new answer with valid params' do
        expect { post api_path, params: valid_params, headers: headers }.to change(Answer, :count).by(1)
      end

      it 'doesnt create the answer with invalid params' do
        expect { post api_path, params: invalid_params, headers: headers }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PUT /api/v1/answers/:id' do
    let!(:answer) { create(:answer, user_id: access_token.resource_owner_id, question: question) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API authorizable' do
      let(:method) { :put }
    end

    context 'authorized' do
      it 'updates the answer with valid params' do
        put api_path, params: valid_params, headers: headers
        answer.reload
        expect(answer.body).to eq valid_params[:answer][:body]
      end

      it 'doesnt update the answer with invalid params' do
        put api_path, params: invalid_params, headers: headers
        answer.reload
        expect(answer.body).to_not eq invalid_params[:answer][:body]
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer, user_id: access_token.resource_owner_id, question: question) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:params) { { access_token: access_token.token } }

      it 'deletes the answer' do
        expect { delete api_path, params: params, headers: headers }.to change(Answer, :count).by(-1)
      end

      it 'returns 200 status' do
        delete api_path, params: params, headers: headers
        expect(response).to be_successful
      end
    end
  end
end
