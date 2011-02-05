class CategoriesController < ApplicationController

  def index
    @recipes = Recipe.order("created_at desc").paginate(:page => params[:page])
    @categories = Category.with_recipes.order("name asc")

    @page_title = "recetas por categorias"
    if not params[:page].nil? and params[:page].to_i > 1
      @page_title << " pagina #{params[:page]}"
    end
    @page_identifier = "categories"
    render :action => "show"
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find_by_slug params[:id]
    @recipes = Recipe.where(:category_id => @category.id).
      order("created_at desc").
      paginate(:page => params[:page])

    @categories = Category.with_recipes.order("name asc")

    @page_title = "recetas de #{@category.name}"
    @page_identifier = "categories"
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @category }
    end
  end

end
