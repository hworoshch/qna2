require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'GET #index' do
    it 'displays all questions' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to controller.question
      end
    end

    context 'with invalid attributes' do
      it 'doesnt saves the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'authenticated user' do
      before { login(user) }

      context 'update his question with valid attributes' do
        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
          question.reload
          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end


        it 'renders update view' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'update his question with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

        it 'doesnt changes question attributes' do
          question.reload
          expect(question.title).to eq 'MyString'
          expect(question.body).to eq 'MyText'
        end

        it' re-renders edit' do
          expect(response).to render_template :update
        end
      end

      context 'tries to update other`s question' do
        let(:others_question) { create(:question, user: create(:user)) }

        it 'doesnt changes question attributes' do
          patch :update, params: { id: others_question, question: { title: 'new title', body: 'new body' } }, format: :js
          question.reload
          expect(question.title).to_not eq 'new title'
          expect(question.body).to_not eq 'new body'
        end
      end

      context 'unauthenticated user tries to update question' do
        it 'doesnt changes question attributes' do
          expect do
            patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
          end.to_not change(question, :body)
        end
      end

    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }
    let!(:others_question) { create(:question, user: create(:user)) }

    context 'authenticated user' do
      before { login(user) }

      it 'deletes own question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'try to delete the other`s question' do
        expect { delete :destroy, params: { id: others_question } }.not_to change(Question, :count)
      end
    end

    it 'unauthenticated user tries to delete the question' do
      expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
    end
  end
end
