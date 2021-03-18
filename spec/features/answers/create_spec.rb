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

    scenario 'answer the question with attached files' do
      within '.new-answer' do
        fill_in 'Your answer', with: 'Answer body'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_button 'Answer'
      end
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'multisessions ' do
    scenario 'added answer from other user and page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('other_user') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'Answer body'
        click_button 'Answer'
        within '.answers' do
          expect(page).to have_content 'Answer body'
        end
      end

      Capybara.using_session('other_user') do
        within '.answers' do
          expect(page).to have_content 'Answer body'
        end
      end
    end
  end

  scenario 'unauthenticated user cant answer the question', js: true do
    visit question_path(question)
    expect(page).to_not have_field 'Your answer'
    expect(page).to_not have_button 'Answer'
  end
end

