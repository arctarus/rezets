require 'acceptance/acceptance_helper'

feature 'Update password', %q{
  In order to increase the security
  As a user
  I want update my password
} do

  background do
    @user = sample :user
    login_as @user
  end

  scenario 'valid password' do
    visit edit_user_path(@user)
    click_link _('change password')
    find('.password').set '123456'
    find('.password-confirmation').set '123456'
    click_button _('change')
    should_be_on edit_user_path(@user)
  end

  scenario 'invalid password' do
    visit edit_user_path(@user)
    click_link _('change password')
    find('.password').set '123456'
    find('.password-confirmation').set '789012'
    click_button _('change')
    should_be_on user_update_password_path(@user)
  end

end
