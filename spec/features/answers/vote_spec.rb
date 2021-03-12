require 'rails_helper'

feature 'User can vote for the answer', %q(
  In order to raise the answer rate
  As an authenticated user
  I'd like to be able to vote for the answer
) do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: create(:user)) }

  describe 'Authenticated user', js: true do
    given!(:other_answer) { create(:answer, question: question, user: user) }

    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'can vote others answer up' do
      within "#answer-#{answer.id}" do
        expect(page.find('.votes-count')).to have_content '0'
        click_on(class: 'vote-up')
        expect(page.find('.votes-count')).to have_content '1'
      end
    end

    scenario 'can vote others answer down' do
      within "#answer-#{answer.id}" do
        expect(page.find('.votes-count')).to have_content '0'
        click_on(class: 'vote-down')
        expect(page.find('.votes-count')).to have_content '-1'
      end
    end

    scenario 'can not vote for the own question' do
      within "#answer-#{other_answer.id}" do
        expect(page).to_not have_css 'a.vote-up'
        expect(page).to_not have_css 'a.vote-down'
      end
    end

    scenario 'can not vote twice' do
      within "#answer-#{answer.id}" do
        click_on(class: 'vote-down')
        click_on(class: 'vote-down')
      end
      expect(page).to have_content "You can not vote twice"
    end

    scenario 'can see rate' do
      create_list(:vote, 3, user: create(:user), value: -1, votable: answer)
      within "#answer-#{answer.id}" do
        click_on(class: 'vote-up')
        expect(page.find('.votes-count')).to have_content '-2'
      end
    end

    scenario 'change vote' do
      within "#answer-#{answer.id}" do
        click_on(class: 'vote-down')
        expect(page.find('.votes-count')).to have_content '-1'
        click_on(class: 'vote-up')
        click_on(class: 'vote-up')
        expect(page.find('.votes-count')).to have_content '1'
      end
    end
  end

  scenario 'Unauthenticated user can not vote for the answer' do
    visit question_path(question)
    expect(page).to_not have_css 'a.vote-up'
    expect(page).to_not have_css 'a.vote-down'
  end
end
