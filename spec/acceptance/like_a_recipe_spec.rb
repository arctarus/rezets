require 'acceptance/acceptance_helper'

feature 'Like a recipe', %q{
  In order to remember my favourite recipes
  As a user
  I want like a recipe
} do

  background do
    @user = sample :user
    @other_user = sample :user
    @recipe = sample :recipe, :author => @other_user
    @other_user.recipes << @recipe
    login_as @user
  end

  scenario 'mark recipe as like', :js => true do
    visit user_recipe_path(@other_user, @recipe)
    click_link _('like?')
    should_see _('you like')
  end

  scenario 'see recipe in likes page' do
    @user.likes << @recipe
    visit user_likes_path(@user)
    should_see @recipe.name
  end

end
