require 'rails_helper'

feature 'user can create question', %q{
  in order to get answer from a community
  as an authenticated user
  i'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe 'authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_button 'Ask'
      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      click_button 'Ask'
      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end