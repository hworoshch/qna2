require 'rails_helper'

feature 'user can sign in', %q{
  in order to ask questions
  as an unauthenticated user
  i'd like to be able to sign in
} do

  given(:user) { create(:user) }
  background do
    visit root_path
    click_on 'Sign in'
  end

  scenario 'registered user tried to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'unregistered user tried to sign in' do
    fill_in 'Email', with: 'shmuser@user.com'
    fill_in 'Password', with: '1234567'
    click_button 'Log in'
    expect(page).to have_content 'Invalid Email or password.'
  end
end