require 'rails_helper'

feature 'User can subscribe on question', %q{
  In order to view new answers
  As an authenticated user
  I'd like to be able to see new answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question, user: create(:user)) }

  describe 'authenticated user', js: true do
    before { sign_in(user) }

    scenario 'as question owner can unsubscribe from new answers' do
      visit question_path(question)
      click_on 'Unsubscribe'
      expect(page).to have_link('Subscribe')
      expect(page).to_not have_link('Unsubscribe')
    end

    scenario 'can subscribe on question' do
      visit question_path(other_question)
      click_on 'Subscribe'
      expect(page).to_not have_link('Subscribe')
      expect(page).to have_link('Unsubscribe')
    end
  end

  scenario 'unauthenticated user cant subscribe on question' do
    visit question_path(question)
    expect(page).to_not have_link('Subscribe')
  end
end
