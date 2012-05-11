class RecipesController < ApplicationController
  load_and_authorize_resource :only => :index
  
  load_and_authorize_resource :user, :find_by => :slug, :except => [:index]
  load_and_authorize_resource :recipe, :find_by => :url, :through => :user, :except => [:index]

  respond_to :html, :json
  before_filter :require_user, :except => [:index, :show, :email, :email_send, :print]


  def index
    @categories = Category.with_recipes.order("name asc")
    @recipes = Recipe.most_popular.paginate :per_page => 10, 
                                            :page => params[:page]
  end

  def show
    @recipes_same_author = @user.recipes.
                                 rejecting(@recipe).
                                 includes(:author, :category).
                                 order('created_at desc').
                                 limit(3)
    @recipes_same_category = Recipe.
      where(:category_id => @recipe.category_id).
      rejecting([*@recipes_same_author, @recipe]).
      includes(:author).
      order('created_at desc').
      limit(3)

    @comment = @recipe.comments.build
    respond_with @recipe do |format|
      format.html { render :layout => 'recipe' }
    end
  end

  def print
    @comment = @recipe.comments.build
    render :layout => 'print'
  end

  def new
    @recipe = current_user.authorings.new
    @recipe.recipe_ingredients.build
  end

  def create
    @recipe = current_user.authorings.new(params[:recipe])
    @recipe.users << current_user
    @recipe.save
    respond_with @recipe, :location => current_user
  end

  def edit
    @recipe = current_user.authorings.find(params[:id])
  end

  def update
    @recipe = current_user.authorings.find(params[:id])
    unless @recipe.update_attributes(params[:recipe])
      @categories = Category.all
    end
    respond_with @recipe, :location => current_user
  end

  def destroy
    @recipe = current_user.recipes.find(params[:id], :include => :ingredients)
    @recipe.destroy
    respond_with @recipe, :location => @user
  end

  def email
    @email_recipe_form = EmailRecipeForm.new
    render :layout => false
  end

  def email_send
    args = params[:email_recipe_form].merge(
      :recipe => @recipe, 
      :user   => current_user)

    @email_recipe_form = EmailRecipeForm.new(args)
    if @email_recipe_form.deliver
      render layout: false
    else
      render 'email', layout: false
    end
  end

  def like
    current_user.like @recipe
  end

  def unlike
    current_user.unlike @recipe
    render 'like'
  end

end
