require 'acceptance/acceptance_helper'

feature 'Send a recipe by email', %q{
  In order to share recipes
  As a guest
  I want send a recipe to my friends
} do

  background do
    @author = sample :user
    @recipe = sample :recipe, :author => @author
    @author.recipes << @recipe
    @email = sample_email
    @message = sample_paragraphs
  end

  scenario 'guest user', :js => true do
    visit user_recipe_path(@author, @recipe)
    click_link _('email')
    fill_in _('your name'), :with => sample_name
    fill_in _('email'),     :with => @email
    click_link _('add a message?')
    fill_in _('message'),   :with => @message
    click_button _('send')
    should_see _('recipe sent')
    last_mail.to.should == [@email]
  end

  scenario 'guest user forget one field', :js => true do
    visit user_recipe_path(@author, @recipe)
    click_link _('email')
    fill_in _('email'),     :with => @email
    click_link _('add a message?')
    fill_in _('message'),   :with => @message
    click_button _('send')
  end

end
