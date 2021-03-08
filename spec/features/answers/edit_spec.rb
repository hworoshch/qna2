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
  end

  scenario 'unauthenticated user cant edit any answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end
end