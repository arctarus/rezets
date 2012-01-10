class CommentsController < ApplicationController
  load_and_authorize_resource :user, :find_by => :slug
  load_and_authorize_resource :recipe, :find_by => :url, :through => :user
  respond_to :html, :json
  layout 'recipe'

  before_filter :require_user

  def create
    @comment = current_user.comments.
      new_with_recipe(params[:comment], @recipe)
    if @comment.save
      redirect_to [@user, @recipe]
    else
      @category = @recipe.category
      @recipes_same_author = @user.recipes.rejecting(@recipe).limit(3)
      @recipes_same_category = @category.recipes.
        rejecting([*@recipes_same_author, @recipe]).limit(3)

      render 'recipes/show'
    end
  end

end
