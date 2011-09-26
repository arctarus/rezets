require 'acceptance/acceptance_helper'

feature 'Follow a user', %q{
  In order to see what other users cook
  As a user
  I want follow other users
} do

  background do
    @user = sample :user
    @other_user = sample :user
    login_as @user
  end

  scenario 'follow', :js => true do
    visit user_path(@other_user)
    click_link _('Follow it.')
    confirm_dialog 
    should_see _("You are following it.")
  end

  scenario 'unfollow', :js => true do
    @user.followings << @other_user

    visit user_path(@other_user)
    click_link _('Stop following')
    confirm_dialog
    should_see _("Follow it.")
  end

end
