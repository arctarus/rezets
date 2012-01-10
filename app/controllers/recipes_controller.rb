class RecipesController < ApplicationController
  respond_to :html, :json, :print
  before_filter :require_user, :except => [:index, :show, :email, :email_send, :print]

  load_and_authorize_resource :user, :find_by => :slug
  load_and_authorize_resource :recipe, :find_by => :url, :through => :user

  def index
    @categories = Category.with_recipes.order("name asc")
    @recipes = Recipe.index.paginate :per_page => 10, 
                                     :page => params[:page]
  end

  def show
    @category = @recipe.category
    @recipes_same_author = @user.recipes.rejecting(@recipe).limit(3)
    @recipes_same_category = @category.recipes.rejecting([*@recipes_same_author, @recipe]).limit(3)
    @comment = @recipe.comments.build
    respond_with @recipe 
  end

  def print
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
    current_user.likes << @recipe
  end

  def unlike
    current_user.recipe_likes.find_by_recipe_id(@recipe.id).destroy
    render 'like'
  end

end
