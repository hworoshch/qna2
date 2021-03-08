require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
        end

        it 'redirects to show' do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
          # expect(response).to redirect_to question
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'doesnt saves a new answer in the database' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.not_to change(Answer, :count)
        end

        it 're-renders with errors' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
          expect(response).to render_template :create
        end
      end
    end

    it 'unauthenticated user tries to create answer' do
      expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.not_to change(Answer, :count)
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:others_answer) { create(:answer, question: question, user: create(:user)) }

    context 'authenticated user' do
      before { login user }

      it 'deletes own answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'try to delete the other`s answer' do
        expect { delete :destroy, params: { question_id: question, id: others_answer } }.not_to change(Answer, :count)
      end
    end

    it 'unauthenticated user tries to delete the answer' do
      expect { delete :destroy, params: { question_id: question, id: answer } }.not_to change(Answer, :count)
    end
  end

end
