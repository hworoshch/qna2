require 'rails_helper'

feature 'User can delete links from the question', %q(
  In order to remove links
  As the author of the question
  I would like to be able to delete links
) do

  describe 'authenticated user', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }
    given!(:link) { create(:link, name: 'Link', url: 'http://rusrails.ru/', linkable: question) }

    scenario 'removes the link in owned question' do
      sign_in(user)
      visit question_path(question)
      within '#question' do
        click_on 'Edit'
        within '#edit-question' do
          click_on 'Delete'
          click_on 'Save'
        end
      end
      expect(page).to_not have_link link.name, href: link.url
    end
  end
end
