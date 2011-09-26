class CommentsController < ApplicationController
  respond_to :html, :xml
  load_and_authorize_resource :user, :find_by => :slug
  before_filter :require_user
  before_filter :find_recipe

  def create
    @comment = current_user.comments.
      new_with_recipe(params[:comment], @recipe)
    if @comment.save
      redirect_to [@user, @recipe]
    else
      @recipes_same_author = Recipe.by_author(@recipe.author.id).not_in(@recipe.id).limit(3)
      @recipes_same_category = Recipe.by_category(@recipe.category.id).
        not_in(@recipes_same_author.map(&:id).push(@recipe.id)).limit(3)

      render 'recipes/show', :layout => 'recipe'
    end
  end

  private

  def find_recipe
    recipe_id = params[:recipe_id].split("-").first.to_i
    @recipe = @user.recipes.find(recipe_id)
  end

end
