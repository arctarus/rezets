class CategoriesController < ApplicationController

  def show
    @user = find_user
    @category = find_category

    if @user.present?
      @categories = @user.categories.order(:name)
      @recipes = @user.authorings.by_category(@category.id)
    else
      @categories = Category.with_recipes.order(:name)
      @recipes = Recipe.by_category(@category.id)
    end

    @recipes = @recipes.paginate(page: params[:page], per_page: 10)

    render "users/show", layout: "users" if @user
  end

  private

  def find_user
    User.find_by_slug(params[:user_id])
  end

  def find_category
    Category.find_by_slug!(params[:id])
  end
end
