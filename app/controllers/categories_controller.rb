class CategoriesController < ApplicationController

  def index
    @recipes = Recipe.order("likes_count desc, updated_at desc").paginate(:page => params[:page])
    @categories = Category.with_recipes.order("name asc")

    if not params[:page].nil? and params[:page].to_i > 1
      @page_title << " pagina #{params[:page]}"
    end
    @page_identifier = "categories"
    render :action => "show"
  end

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

    respond_to do |format|
      if @user
        format.html { render :layout => 'users' }
        format.xml { render :xml => @category }
      else
        format.html { render }
        format.xml { render :xml => @category }
      end
    end
  end

end
