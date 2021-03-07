require 'rails_helper'

feature 'user can sign up', %q{
  in order to use site
  as an unregistered user
  i'd like to be able to sign up
} do

  given(:user) { build(:user) }

  background do
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
  end

  scenario 'unregistered user tries to sign up' do
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'registered user tries to sign up' do
    user.save!
    click_on 'Sign up'
    expect(page).to have_content 'Email has already been taken'
  end
end