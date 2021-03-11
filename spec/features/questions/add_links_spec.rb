require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  describe 'authenticated user', js: true do
    given(:user) { create(:user) }
    given(:url) { 'http://rusrails.ru/' }
    given(:other_url) { 'http://thinknetica.com/' }
    given(:gist_url) { 'https://gist.github.com/hworoshch/ac5be56d857bd76b221e1966173a53fb' }

    background do
      sign_in user
      visit new_question_path
      fill_in 'Title', with: 'Question with link'
      fill_in 'Body', with: 'Text of the question with link'
      click_on 'Add link'
      fill_in 'Link name', with: 'My link'
      fill_in 'URL', with: url
    end

    scenario 'adds one link when ask question' do
      click_on 'Ask'
      expect(page).to have_link 'My link', href: url
    end

    scenario 'adds two links when ask question' do
      click_on 'Add link'
      within all('.link-fields').last do
        fill_in 'Link name', with: 'Other link'
        fill_in 'URL', with: other_url
      end
      click_on 'Ask'
      expect(page).to have_link 'My link', href: url
      expect(page).to have_link 'Other link', href: other_url
    end

    scenario 'adds gist link when ask question' do
      fill_in 'URL', with: gist_url
      click_on 'Ask'
      expect(page).to have_content 'qna'
      expect(page).to have_content 'just tesing...'
    end

    scenario 'adds invalid link when ask question' do
      fill_in 'URL', with: 'wrong/url'
      click_on 'Ask'
      expect(page).to have_content 'Links url is invalid'
      expect(page).to_not have_link 'My link', href: 'wrong/url'
    end
  end
end