require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    let!(:resource) { create(:question, user: user, files: [file]) }
    let!(:others_resource) { create(:question, user: create(:user), files: [file]) }

    context 'authenticated user' do
      before { login user }

      context 'is owner of the resource' do
        it 'can remove attachment' do
          expect { delete :destroy, params: { id: resource.files.first }, format: :js }.to change(resource.files, :count).by(-1)
        end

        it 'render destroy' do
          delete :destroy, params: { id: resource.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'isnt owner of the resource' do
        it 'cant remove attachment' do
          expect { delete :destroy, params: { id: others_resource.files.first }, format: :js }.to_not change(others_resource.files, :count)
        end

        it 'render 403' do
          delete :destroy, params: { id: resource.files.first }, format: :js
          expect(response.status).to eq 403
        end
      end
    end

    context 'unauthenticated user' do
      it 'cant remove attachment' do
        expect { delete :destroy, params: { id: resource.files.first }, format: :js }.to_not change(resource.files, :count)
      end

      it 'render 403' do
        delete :destroy, params: { id: resource.files.first }, format: :js
        expect(response.status).to eq 403
      end
    end
  end
end
