class CategoriesController < ApplicationController
  respond_to :html, :xml, :json

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @user = User.find_by_slug(params[:user_id]) if params[:user_id]
    @category = Category.find_by_slug(params[:id])

    if @user
      @recipes = @user.recipes.where(:category_id => @category.id).
        order("updated_at desc").
        paginate(:page => params[:page], :per_page => 10)
      @categories = Category.joins(:recipes).where({:recipes => { :author_id => @user.id }}).uniq
    else
      @recipes = Recipe.where(:category_id => @category.id).
        order("likes_count desc, updated_at desc").
        paginate(:page => params[:page], :per_page => 10)
      @categories = Category.with_recipes.order("name asc")
    end

    respond_with @category do |format|
      format.html { render :layout => 'users' if @user }
    end
 end

end
