require 'rails_helper'

feature 'user can sign in', %q{
  in order to ask questions
  as an unauthenticated user
  i'd like to be able to sign in
} do

  given(:user) { create(:user) }
  background { visit new_user_session_path }

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

  scenario 'user tries to sign in with oauth github' do
    mock_auth :github, 'user@user.com'
    click_on 'Sign in with GitHub'
    expect(page).to have_content 'Successfully authenticated from Github account.'
  end

  scenario 'user tries to sign in with oauth vkontakte' do
    mock_auth :vkontakte
    click_on 'Sign in with Vkontakte'
    fill_in 'Email', with: 'new@user.com'
    click_on 'Sign up'
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
    open_email 'new@user.com'
    current_email.click_link 'Confirm your account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end
end