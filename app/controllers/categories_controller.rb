class CategoriesController < ApplicationController

  def show
    @user = User.where(slug: params[:user_id]).first
    @category = Category.where(slug: params[:id]).first

    if @user.present?
      @categories = @user.categories.order(:name)
      @recipes = @user.authorings.by_category(@category.id)
    else
      @categories = Category.with_recipes.order(:name)
      @recipes = Recipe.by_category(@category.id)
    end

    @recipes = @recipes.paginate(page: params[:page], per_page: 10)

    if @user
      render 'users/show', layout: 'users'
    end
  end
end
