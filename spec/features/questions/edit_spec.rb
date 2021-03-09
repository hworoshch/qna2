require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:others_question) { create(:question, user: create(:user)) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)
    end

    scenario 'edits his question' do
      visit question_path(question)
      within("#question") do
        click_on 'Edit'
        fill_in 'Title', with: 'new title'
        fill_in 'Body', with: 'new body'
        click_on 'Save'
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'new title'
        expect(page).to have_content 'new body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      visit question_path(question)
      within("#question") do
        click_on 'Edit'
        fill_in 'Body', with: ''
        click_on 'Save'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other`s question" do
      visit question_path(others_question)
      within("#question") do
        expect(page).to_not have_link 'Edit'
      end
    end

    context 'edit with attachments' do
      background do
        visit question_path(question)
        within("#question") do
          click_on 'Edit'
          within("#edit-question") do
            attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
            click_on 'Save'
          end
        end
      end

      scenario 'add files' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'delete files' do
        first('#question .attachment').click_on 'Delete'
        within("#question") do
          expect(page).to_not have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'tries to delete others question files' do
        click_link 'Sign out'
        sign_in(create(:user))
        visit question_path(question)
        within first("#question .attachment") { expect(page).to_not have_link 'Delete' }
      end
    end
  end

  scenario 'unauthenticated user cant edit any question' do
    visit question_path(question)
    within("#question") do
      expect(page).to_not have_link 'Edit'
    end
  end
end
