class RecipesController < ApplicationController
  respond_to :html
  before_filter :require_user, :except => [:index, :show, :email, :email_send]
  before_filter :find_recipe, :except => [:index, :new, :create, :edit, :update, :destroy]

  def index
    @recipes = Recipe.order("likes_count desc, updated_at desc").
      paginate :per_page => 10, :page => params[:page]
    @categories = Category.with_recipes.order("name asc")
  end

  def show
    @recipes_same_author = Recipe.by_author(@recipe.author.id).not_in(@recipe.id).limit(3)
    @recipes_same_category = Recipe.by_category(@recipe.category.id).
      not_in(@recipes_same_author.map(&:id).push(@recipe.id)).limit(3)
    @comment = @recipe.comments.build
    render :layout => 'recipe'
  end

  def print
    @recipes_same_author = Recipe.by_author(@recipe.author.id).not_in(@recipe.id).limit(3)
    @recipes_same_category = Recipe.by_category(@recipe.category.id).
      not_in(@recipes_same_author.map(&:id).push(@recipe.id)).limit(3)
    @comment = @recipe.comments.build
    render layout: 'recipe', action: 'show'
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
    @recipe.updated_at = Time.current
    unless @recipe.update_attributes(params[:recipe])
      @categories = Category.all
    end
    respond_with @recipe, :location => current_user
  end

  def destroy
    @recipe = current_user.recipes.find(params[:id], :include => :ingredients)
    @recipe.destroy
    respond_with @author
  end

  def email
    @email_recipe_form = EmailRecipeForm.new
    render :layout => false
  end

  def email_send
    @email_recipe_form = EmailRecipeForm.new(params[:email_recipe_form])
    @email_recipe_form.recipe = @recipe
    @email_recipe_form.user = current_user
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

  private

  def find_recipe
    recipe_id = params[:id].split("-").first
    @author = User.find_by_slug params[:user_id]
    @recipe = @author.recipes.find(recipe_id, :include => :ingredients)
  end

end
