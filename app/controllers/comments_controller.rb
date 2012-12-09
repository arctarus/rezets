class CommentsController < ApplicationController
  layout 'recipe'
  respond_to :html, :json

  load_and_authorize_resource :user, :find_by => :slug
  load_and_authorize_resource :recipe, :find_by => :url, :through => :user

  before_filter :require_user

  def create
    @comment = CreateComment.new(current_user, @recipe, params[:comment]).call

    if @comment.valid?
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
