require 'acceptance/acceptance_helper'

feature 'Send feedback', %q{
  In order to contact with rezets creators
  As a guess
  I want to send feedback
} do

  scenario 'filling all fields' do
    visit homepage
    click_link _('contact')
    fill_in _('name'), :with => sample_name
    fill_in _('email'), :with => sample_email
    fill_in _('message'), :with => sample_paragraphs
    click_button _('send')
    should_be_on homepage
  end

  scenario 'forget email' do
    visit homepage
    click_link _('contact')
    fill_in _('name'), :with => sample_name
    fill_in _('message'), :with => sample_paragraphs
    click_button _('send')
    should_be_on feedback_index_path
  end

end
