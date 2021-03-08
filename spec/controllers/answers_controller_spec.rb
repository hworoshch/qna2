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

        it 'renders create template' do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'doesnt saves a new answer in the database' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.not_to change(Answer, :count)
        end

        it 'renders create template' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
          expect(response).to render_template :create
        end
      end
    end

    it 'unauthenticated user tries to create answer' do
      expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.not_to change(Answer, :count)
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'authenticated user' do
      before { login(user) }

      context 'update his answer with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'corrected answer' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'corrected answer'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'corrected answer' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'update his answer with invalid attributes' do
        it 'doesn`t change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'tries to update other`s answer' do
      end
    end

    context 'unauthenticated user tries to update answer' do
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
