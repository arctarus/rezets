class RecipesController < ApplicationController
  layout 'base'
  
  before_filter :require_user, :only => [:new, :create, :edit, :update, :destroy, :save, :remove]  
  before_filter :find_recipe, :only => [:show, :edit, :update, :destroy]

  # GET /recipes
  # GET /recipes.xml
  def index
    @featured_recipe = Recipe.random
#   @ingredients = Ingredient.most_popular.all(:limit => 30)
#   @ingredients.sort! {|x,y| x.name <=> y.name }
    @categories = Category.all(:order => "name asc")
    @categories.delete_if {|c| c.recipes.blank? }
    @page_title = _("recetas de cocina")
    respond_to do |format|
      format.html { render } # index.html.erb
      format.xml  { render :xml => @recipes }
    end
  end

  # GET /recipes/1
  # GET /recipes/1.xml
  def show
    @comments = @recipe.comments.paginate(:page => params[:page], :per_page => 20)
    @comment = Comment.new unless current_user.nil?
    @page_title = _("#{@recipe.name} por #{@recipe.author.name}")
    @page_class = "hrecipe"
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @recipe }
    end
  end

  # GET /recipes/new
  # GET /recipes/new.xml
  def new
    @page_title = _("receta nueva")
    @categories = Category.all(:order => "name asc")
    @recipe = Recipe.new
    @recipe.recipe_ingredients.build
    @recipe.author = @user
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @recipe }
    end
  end

  # GET /recipes/1/edit
  def edit
    @categories = Category.all(:order => "name asc")
    @page_title = _("editando #{@recipe.name}")
  end

  # POST /recipes
  # POST /recipes.xml
  def create
    @recipe = Recipe.new(params[:recipe])
    @recipe.author = current_user
    @recipe.users << current_user
    respond_to do |format|
      if @recipe.save
        flash[:notice] = _('Receta creada correctamente.')
        format.html { redirect_to current_user }
        format.xml  { render :xml => @recipe, :status => :created, :location => @recipe }
      else
        @categories = Category.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @recipe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /recipes/1
  # PUT /recipes/1.xml
  def update
    @recipe.updated_at = Time.now
    respond_to do |format|
      if @recipe.update_attributes(params[:recipe])
        flash[:notice] = 'receta actualizada correctamente.'
        format.html { redirect_to(current_user) }
        format.xml  { head :ok }
      else
        @categories = Category.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recipe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.xml
  def destroy
    author = @recipe.author
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to author }
      format.xml  { head :ok }
    end
  end

  # POST /recipes/1/save
# def save
#   recipe = Recipe.find params[:id]
#   current_user.recipes << recipe
#   redirect_to user
# end

# # POST /recipes/1/save
# def remove
#   recipe = Recipe.find params[:id]
#   current_user.recipes.delete(recipe)
#   redirect_to user
# end


  private
    def find_recipe
      recipe_id = params[:id].split("-").first
      @author = User.find_by_slug params[:user_id]
      @recipe = Recipe.find_by_id_and_author_id(recipe_id, @author.id, 
        :include => :ingredients)
    end

end
