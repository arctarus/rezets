require 'acceptance/acceptance_helper'

feature 'Send feedback', %q{
  In order to contact with rezets creators
  As a guess
  I want to send feedback
} do

  background do
    clear_mails
    @name     = sample_name
    @email    = sample_email
    @message  = sample_paragraphs
  end

  scenario 'filling all fields' do
    visit homepage
    click_link _('contact')
    fill_in _('name'),    :with => @name
    fill_in _('email'),   :with => @email
    fill_in _('message'), :with => @message
    click_button _('send')
    should_be_on homepage

    last_mail.from.should == [@email]
    last_mail.to.should == ["rezets.com@gmail.com"]
  end

  scenario 'forget email' do
    visit homepage
    click_link _('contact')
    fill_in _('name'),    :with => sample_name
    fill_in _('message'), :with => sample_paragraphs
    click_button _('send')
    should_be_on feedback_index_path
    should_see _('It looks like to be missing some data')
  end

end
