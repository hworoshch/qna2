require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  describe 'Authenticated user answer the question', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }
    given(:url) { 'http://rusrails.ru/' }
    given(:other_url) { 'http://thinknetica.com/' }
    given(:gist_url) { 'https://gist.github.com/hworoshch/ac5be56d857bd76b221e1966173a53fb' }

    background do
      sign_in user
      visit question_path(question)
      fill_in 'Your answer', with: 'Answer body'
      click_on 'Add link'
      fill_in 'Link name', with: 'My link'
      fill_in 'URL', with: url
    end

    scenario 'adds one link when answer the question' do
      click_button 'Answer'
      within '.answers' do
        expect(page).to have_link 'My link', href: url
      end
    end

    scenario 'adds two links when answer the question' do
      click_on 'Add link'
      within all('.link-fields').last do
        fill_in 'Link name', with: 'Other link'
        fill_in 'URL', with: other_url
      end
      click_button 'Answer'
      within '.answers' do
        expect(page).to have_link 'My link', href: url
        expect(page).to have_link 'Other link', href: other_url
      end
    end

    scenario 'adds gist link when answer the question' do
      fill_in 'URL', with: gist_url
      click_button 'Answer'
      within '.answers' do
        expect(page).to have_content 'qna'
        expect(page).to have_content 'just tesing...'
      end
    end

    scenario 'adds invalid link when answer the question' do
      fill_in 'URL', with: 'wrong/url'
      click_button 'Answer'
      within '.answer-errors' do
        expect(page).to have_content 'Links url is invalid'
        expect(page).to_not have_link 'My link', href: 'wrong/url'
      end
    end
  end
end
