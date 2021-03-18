require 'rails_helper'

feature 'User can add comments to the answer', %q(
  In order to comment the answer
  As an authenticated user
  I'd like to be able to add comments
), js: true do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:comment_text) { 'Text of comment' }

  describe 'Authenticated user' do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'add valid comment' do
      within ("#answer-#{answer.id}") do
        click_on 'Add comment'
        fill_in 'Comment body', with: comment_text
        click_on 'Comment'
        expect(page).to have_content comment_text
      end
    end

    scenario 'add invalid comment' do
      within ("#answer-#{answer.id}") do
        click_on 'Add comment'
        fill_in 'Comment body', with: ''
        click_on 'Comment'
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user can not add comment' do
    visit question_path(question)
    expect(page).to_not have_link 'Add comment'
  end

  context 'Multiple sessioins', js: true do
    given(:comment) { Comment.last }

    scenario 'comment appears on others page' do
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within ("#answer-#{answer.id}") do
          click_on 'Add comment'
          fill_in 'Comment body', with: comment_text
          click_on 'Comment'
          expect(page).to have_content comment_text
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content comment_text
        end
      end
    end
  end
end
