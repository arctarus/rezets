require 'acceptance/acceptance_helper'

feature 'User see a category' do

  background do
    @user = sample :user
    @category = sample :category
    @recipe = sample :recipe, :author   => @user,
                              :category => @category
    @user.recipes << @recipe
    login_as @user
  end

  scenario 'example' do
    should_see @recipe.name
    click_link @category.name
    should_see @recipe.name
  end

end
