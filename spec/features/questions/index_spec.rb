require 'rails_helper'

feature 'any user can see the list of questions', %q{
  in order to get answer from a community
  as an guest user
  i'd like to be able to see the list of questions
} do

  given(:user) { create(:user) }
  given!(:question) { create_list(:question, 5, user: user, title: 'MyString') }

  scenario 'any user can see the list of questions' do
    visit questions_path
    expect(page).to have_content('MyString', count: 5)
  end
end