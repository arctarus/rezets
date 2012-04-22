require 'acceptance/acceptance_helper'

feature 'See categories' do

  background do
    @user = sample :user
    @category = sample :category
    @recipe = sample :recipe, :author => @user, :category => @category
    @user.recipes << @recipe
  end


  scenario 'general' do
    visit category_path(@category)
    should_see @recipe.name
    click_link @recipe.name
    should_be_on user_recipe_path(@user, @recipe)
  end

  scenario "user" do
    visit user_category_path(@user, @category)
    should_see @recipe.name
  end

end
