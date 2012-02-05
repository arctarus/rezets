require 'acceptance/acceptance_helper'

feature 'Make a comment in a recipe', %q{
  In order to talk with the author of recipe
  As a user
  I want make a comment
} do

  background do
    @author = sample :user
    @recipe = sample :recipe, :author => @author
    @author.recipes << @recipe
    @user = sample :user
    @comment = sample_paragraphs
    login_as @user
  end

  scenario 'with message' do
    visit user_recipe_path(@author, @recipe)
    fill_in @user.name, :with => @comment
    click_button _('Make a comment')
    within '.comment' do
      should_see @user.name
    end
    last_mail.to.should == [@author.email]
  end

  scenario 'without message' do
    visit user_recipe_path(@author, @recipe)
    click_button _('Make a comment')
    should_see _("Can't be blank")
  end

end
