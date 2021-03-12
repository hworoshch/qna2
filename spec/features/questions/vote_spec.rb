require 'rails_helper'

feature 'User can vote for the question', %q(
  In order to raise the question rate
  As an authenticated user
  I'd like to be able to vote for the question
) do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: create(:user)) }
  given!(:other_question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'can vote others question up' do
      within "#question-#{question.id}" do
        expect(page.find('.votes-count')).to have_content '0'
        click_on(class: 'vote-up')
        expect(page.find('.votes-count')).to have_content '1'
      end
    end

    scenario 'can vote others question down' do
      within "#question-#{question.id}" do
        expect(page.find('.votes-count')).to have_content '0'
        click_on(class: 'vote-down')
        expect(page.find('.votes-count')).to have_content '-1'
      end
    end

    scenario 'can not vote for the own question' do
      visit question_path(other_question)
      within "#question-#{other_question.id}" do
        expect(page).to_not have_css 'a.vote-up'
        expect(page).to_not have_css 'a.vote-down'
      end
    end

    scenario 'can not vote twice' do
      within "#question-#{question.id}" do
        click_on(class: 'vote-down')
        click_on(class: 'vote-down')
      end
      expect(page).to have_content "You can not vote twice"
    end

    scenario 'can see rate' do
      create_list(:vote, 3, user: create(:user), value: 1, votable: question)
      within "#question-#{question.id}" do
        click_on(class: 'vote-up')
        expect(page.find('.votes-count')).to have_content '4'
      end
    end

    scenario 'change vote' do
      within "#question-#{question.id}" do
        click_on(class: 'vote-down')
        expect(page.find('.votes-count')).to have_content '-1'
        click_on(class: 'vote-up')
        click_on(class: 'vote-up')
        expect(page.find('.votes-count')).to have_content '1'
      end
    end
  end

  scenario 'Unauthenticated user can not vote for the question' do
    visit question_path(question)
    expect(page).to_not have_css 'a.vote-up'
    expect(page).to_not have_css 'a.vote-down'
  end
end
