require 'rails_helper'

feature 'user can sign out', %q{
  in order to cancel session
  as an authenticated user
  i'd like to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'authenticated user tries to sign out' do
    sign_in(user)
    visit root_path
    click_on 'Sign out'
    expect(page).to have_content "Signed out successfully."
  end

end

