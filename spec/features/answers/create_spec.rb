require 'rails_helper'

feature 'authenticated user can create answer on question', %q(
  in order to help someone
  as an authenticated user
  i'd like to be able to answer the question
) do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answer the question' do
      fill_in 'Your answer', with: 'Answer body'
      click_button 'Answer'
      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Answer body'
      end
    end

    scenario 'answer the question with errors' do
      click_button 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'unauthenticated user cant answer the question', js: true do
    visit question_path(question)
    expect(page).to_not have_field 'Your answer'
    expect(page).to_not have_button 'Answer'
  end
end

