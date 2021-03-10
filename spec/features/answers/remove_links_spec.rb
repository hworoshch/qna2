require 'rails_helper'

feature 'User can delete links from the answer', %q(
  In order to remove links
  As the author of the answer
  I would like to be able to delete links
) do

  describe 'authenticated user', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }
    given!(:answer) { create(:answer, question: question, user: user) }
    given!(:link) { create(:link, name: 'Link', url: 'http://rusrails.ru/', linkable: answer) }

    scenario 'removes the link in owned answer' do
      sign_in(user)
      visit question_path(question)
      within "#answer-#{answer.id}" do
        click_on 'Edit'
        within '.link-fields' do
          click_on 'Delete'
        end
        click_on 'Save'
      end
      expect(page).to_not have_link link.name, href: link.url
    end
  end
end
