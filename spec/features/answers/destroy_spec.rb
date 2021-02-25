require 'rails_helper'

feature 'user can delete own answers', %q{
  in order to delete answer
  as an authenticated user
  i'd like to be able to delete only own answer
} do

  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'authenticated user can delete own answer' do
    sign_in user
    visit question_path(question)
    click_on 'Delete answer'
  end

  scenario 'authenticated user cant delete other`s answer' do
    sign_in(second_user)
    visit question_path(question)
    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'unauthenticated user cant delete answers' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete answer'
  end
end