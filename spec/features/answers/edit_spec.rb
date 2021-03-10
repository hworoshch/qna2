require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:others_answer) { create(:answer, question: question, user: create(:user)) }
  given!(:url) { 'http://rusrails.ru/' }
  given!(:other_url) { 'http://thinknetica.com/' }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      within("#answer-#{answer.id}") do
        click_on 'Edit'
        fill_in 'Your answer', with: 'corrected answer'
        click_on 'Save'
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'corrected answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      within("#answer-#{answer.id}") do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other`s answer" do
      within("#answer-#{others_answer.id}") do
        expect(page).to_not have_link 'Edit'
      end
    end

    context 'edit with attachments' do
      background do
        within("#answer-#{answer.id}") do
          click_on 'Edit'
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
        end
      end

      scenario 'add files' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'delete files' do
        first("#answer-#{answer.id} .attachment").click_on 'Delete'
        within("#answer-#{answer.id}") do
          expect(page).to_not have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'tries to delete others question files' do
        click_link 'Sign out'
        sign_in(create(:user))
        visit question_path(question)
        within first("#answer-#{answer.id} .attachment") { expect(page).to_not have_link 'Delete' }
      end
    end

    scenario 'adds link when edit the answer' do
      within "#answer-#{answer.id}" do
        click_on 'Edit'
        click_on 'Add link'
        within all('.link-fields').last do
          fill_in 'Link name', with: 'Other link'
          fill_in 'URL', with: other_url
        end
        click_button 'Save'
      end
      within '.answers' do
        expect(page).to have_link 'Other link', href: other_url
      end
    end
  end

  scenario 'unauthenticated user cant edit any answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end
end