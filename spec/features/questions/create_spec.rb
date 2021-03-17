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

    scenario 'asks a question with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_button 'Ask'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    context 'multisessions', js: true do
      scenario 'added question from other user and page', js: true do
        Capybara.using_session('user') do
          sign_in(user)
          visit questions_path
        end

        Capybara.using_session('other_user') do
          visit questions_path
        end

        Capybara.using_session('user') do
          click_on 'Ask question'
          fill_in 'Title', with: 'Test question'
          fill_in 'Body', with: 'text text text'
          click_on 'Ask'
          expect(page).to have_content 'Your question successfully created.'
          expect(page).to have_content 'Test question'
          expect(page).to have_content 'text text text'
        end

        Capybara.using_session('other_user') do
          expect(page).to have_content 'Test question'
          expect(page).to have_content 'text text text'
        end
      end
    end
  end

  scenario 'unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end