class CategoriesController < ApplicationController
  respond_to :html, :xml, :json
  load_and_authorize_resource :user, find_by: :slug
  load_and_authorize_resource :category, through: :user, find_by: :slug, shallow: true

  def show
    if @user
      @categories = @user.categories.order(:name)
      @recipes = @user.authorings.by_category(@category.id)
    else
      @categories = Category.with_recipes.order(:name)
      @recipes = Recipe.by_category(@category.id)
    end
    @recipes = @recipes.paginate(:page => params[:page], :per_page => 10)

    respond_with @category do |format|
      format.html { render :layout => 'users' if @user }
    end
  end

end
