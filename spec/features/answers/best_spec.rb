require 'rails_helper'

feature 'The author of the question can mark one answer as the best', %q(
  In order to mark the correct answer
  As an authenticated user and question author
  I'd like to be able to mark one answer as the best
) do

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: question, user: create(:user)) }

  describe 'authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'mark one answer as the best' do
      within "#answer-#{answers.first.id}" do
        click_on 'Best'
      end
      wait_for_ajax
      within ".best-answer" do
        expect(page).to have_content answers.first.body
        expect(page).to_not have_link 'Best'
      end
    end

    scenario 'mark other answer as the best' do
      within "#answer-#{answers.last.id}" do
        click_on 'Best'
      end
      wait_for_ajax
      within ".best-answer" do
        expect(page).to have_content answers.last.body
        expect(page).to_not have_link 'Best'
      end
    end
  end

  scenario 'authenticated user tries to mark answer as the best in others question' do
    sign_in(other_user)
    visit question_path(question)
    within "#answer-#{answers.first.id}" do
      expect(page).to_not have_link 'Best'
    end
  end

  scenario 'unauthenticated user cant mark answer as the best' do
    visit question_path(question)
    expect(page).to_not have_link 'Best'
  end
end
