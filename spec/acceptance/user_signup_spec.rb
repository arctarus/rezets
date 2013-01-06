require 'acceptance/acceptance_helper'

feature 'User signup', %q{
  In order to enjoy cooking
  As a user
  I want sign up into rezets
} do

  background do
    @sender     = sample :user
    @invitation = sample :invitation, :sender => @sender
  end

  scenario 'fill fields correctly' do
    visit new_user_path(:token => @invitation.token)

    fill_in _('name'),              :with => sample_name
    find('.password').set '123456'
    find('.password-confirmation').set '123456'
    fill_in _('address of your page in rezets.com'), :with => sample_name.parameterize
    click_button _('continue')

    new_user = User.last
    should_be_on user_path(new_user)
    should_see _('Welcome to rezets.com!')
    should_see new_user.name
    new_user.email.should == @invitation.email
  end

  scenario 'forgot fill one field' do
    visit new_user_path(:token => @invitation.token)

    fill_in _('name'),              :with => sample_name
    find('.password').set '123456'
    fill_in _('address of your page in rezets.com'), :with => sample_name.parameterize
    click_button _('continue')
    should_be_on users_path
    should_see _('It looks like to be missing some data')
  end

end
