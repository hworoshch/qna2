require 'sphinx_helper'

feature 'User can perform search', %q(
  In order to find information
  As a user
  I'd like to be able to perform search
) do
  given!(:users) { create_list(:user, 3) }
  given(:user) { users.first }
  given!(:questions) { create_list(:question, 3, user: user) }
  given(:question) { questions.first }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }
  given(:answer) { answers.first }
  given!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
  given(:comment) { comments.first }
  given!(:indicies) { %w[Question Answer Comment User] }
  background { visit search_path }

  describe 'of question', sphinx: true, js: true do
    scenario 'only in questions' do
      check 'Question', allow_label_click: true
      fill_in :search_q, with: question.title
      ThinkingSphinx::Test.run do
        click_button 'Search'
      end
      expect(page).to have_link question.title, href: question_path(question)
      expect(page).to have_content question.body
      (questions - [question]).each do |q|
        expect(page).to_not have_link q.title, href: question_path(q)
      end
    end

    scenario 'in other indices' do
      (indicies - ['Question']).each do |index|
        check index, allow_label_click: true
      end
      fill_in :search_q, with: question.title
      ThinkingSphinx::Test.run do
        click_button 'Search'
      end
      expect(page).to_not have_link question.title, href: question_path(question)
    end
  end

  describe 'of answer', sphinx: true, js: true do
    scenario 'only in answers' do
      check 'Answer', allow_label_click: true
      fill_in :search_q, with: answer.body
      ThinkingSphinx::Test.run do
        click_button 'Search'
      end
      expect(page).to have_link answer.question.title, href: question_path(answer.question)
      expect(page).to have_content answer.body
      (answers - [answer]).each do |a|
        expect(page).to_not have_content a.body
      end
    end

    scenario 'in other indices' do
      (indicies - ['Answer']).each do |index|
        check index, allow_label_click: true
      end
      fill_in :search_q, with: answer.body
      ThinkingSphinx::Test.run do
        click_button 'Search'
      end
      expect(page).to_not have_content answer.body
    end
  end

  describe 'of comment', sphinx: true, js: true do
    scenario 'only in comments' do
      check 'Comment', allow_label_click: true
      fill_in :search_q, with: comment.body
      ThinkingSphinx::Test.run do
        click_button 'Search'
      end
      expect(page).to have_link comment.commentable.title, href: question_path(comment.commentable)
      expect(page).to have_content comment.body
      (comments - [comment]).each do |c|
        expect(page).to_not have_content c.body
      end
    end

    scenario 'in other indices' do
      (indicies - ['Comment']).each do |index|
        check index, allow_label_click: true
      end
      fill_in :search_q, with: comment.body
      ThinkingSphinx::Test.run do
        click_button 'Search'
      end
      expect(page).to_not have_content comment.body
    end
  end

  describe 'of user', sphinx: true, js: true do
    scenario 'only in users' do
      check 'User', allow_label_click: true
      fill_in :search_q, with: user.email
      ThinkingSphinx::Test.run do
        click_button 'Search'
      end
      expect(page).to have_content user.email
      (users - [user]).each do |u|
        expect(page).to_not have_content u.email
      end
    end

    scenario 'in other indices' do
      (indicies - ['User']).each do |index|
        check index, allow_label_click: true
      end
      fill_in :search_q, with: user.email
      ThinkingSphinx::Test.run do
        click_button 'Search'
      end
      expect(page).to_not have_content user.email
    end
  end

  describe 'of keyword', sphinx: true, js: true do
    given(:keyword) { 'keyword' }
    given!(:user) { create(:user, email: "#{keyword}@user.com") }
    given!(:question) { create(:question, title: "#{keyword} question", user: user) }
    given!(:answer) { create(:answer, body: "#{keyword} asnwer", user: user ) }
    given!(:comment) { create(:comment, body: "#{keyword} comment", commentable: question, user: user ) }

    scenario 'in all indices' do
      fill_in :search_q, with: keyword
      ThinkingSphinx::Test.run do
        click_button 'Search'
      end
      expect(page).to have_link question.title, href: question_path(question)
      expect(page).to have_content question.body
      expect(page).to have_link answer.question.title, href: question_path(answer.question)
      expect(page).to have_content answer.body
      expect(page).to have_link comment.commentable.title, href: question_path(comment.commentable)
      expect(page).to have_content comment.body
      expect(page).to have_content user.email
    end
  end
end
