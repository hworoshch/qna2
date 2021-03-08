require 'rails_helper'

feature 'user can delete own answers', %q{
  in order to delete answer
  as an authenticated user
  i'd like to be able to delete only own answer
} do

  given(:user) { create(:user) }
  given(:others_question) { create(:question, user: create(:user)) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'authenticated user can delete own answer', js: true do
    sign_in(user)
    visit question_path(question)
    within("#answer-#{answer.id}") { click_on 'Delete' }
    expect(page).to_not have_content answer.body
  end

  scenario 'authenticated user cant delete other`s answer', js: true do
    visit question_path(others_question)
    expect(page).to_not have_link 'Delete'
  end

  scenario 'unauthenticated user cant delete answer', js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Delete'
  end
end