class CategoriesController < ApplicationController
  respond_to :html, :xml, :json
  load_and_authorize_resource :user, find_by: :slug
  load_and_authorize_resource :category, through: :user, find_by: :slug, shallow: true

  def show
    if @user
      @recipes = @user.recipes.by_category(@category.id).
        order("updated_at desc").
        paginate(:page => params[:page], :per_page => 10)
      @categories = @user.categories
    else
      @recipes = Recipe.by_category(@category.id).
        order("likes_count desc, updated_at desc").
        paginate(:page => params[:page], :per_page => 10)
      @categories = Category.with_recipes.order(:name)
    end

    respond_with @category do |format|
      format.html { render :layout => 'users' if @user }
    end
 end

end
