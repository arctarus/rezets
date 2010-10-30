class CategoriesController < ApplicationController
  layout "base"

  def index
    @recipes = Recipe.all(:order => "created_at desc").paginate(:page => params[:page], :per_page => 10)
    @categories = Category.all(:order => "name asc")
    @categories.delete_if {|c| c.recipes.size <= 0 }
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
    @recipes = Recipe.all(:conditions => {
      :category_id => @category.id },
      :order => "created_at desc").paginate(:page => params[:page], :per_page => 10)
    @categories = Category.all(:order => "name asc")
    @categories.delete_if {|c| c.recipes.size <= 0 }
    @page_title = "recetas de #{@category.name}"
    @page_identifier = "categories"
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @category }
    end
  end

end
