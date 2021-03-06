require 'rails_helper'

feature 'any user can see the question and the list of answers', %q{
  in order to get answer for a question
  as an any user
  i'd like to be able to see the question and the list of answers
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, question: question, user: user) }

  scenario 'any user can see the question and the list of answers' do
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end