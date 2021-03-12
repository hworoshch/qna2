require 'rails_helper'

feature 'user can delete own question', %q{
  in order to delete question
  as an authenticated user
  i'd like to be able to delete only own question
} do

  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'authenticated user delete own question' do
    sign_in(user)
    visit question_path(question)
    within("#question-#{question.id}") { click_on 'Delete' }
    expect(page).to have_content 'Your question has been deleted.'
    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario 'authenticated user cant delete other`s questions' do
    sign_in(second_user)
    visit question_path(question)
    within("#question-#{question.id}") { expect(page).to_not have_link 'Delete' }
  end

  scenario 'unauthenticated user cant delete questions' do
    visit question_path(question)
    within("#question-#{question.id}") { expect(page).to_not have_link 'Delete' }
  end
end