class CommentsController < ApplicationController

  before_filter :require_user, :only => [:create]

  # POST /comments
  # POST /comments.xml
  def create
    recipe_id = params[:recipe_id].split("-").first
    @recipe = Recipe.find(recipe_id)
    params[:comment][:recipe_id] = @recipe.id
    params[:comment][:user_id] = current_user.id
    @comment = Comment.new(params[:comment])
    respond_to do |format|
      if @comment.save
        users = @recipe.comments.collect {|c| c.user}.uniq
        users << @recipe.author unless users.include? @recipe.author
        users.delete(current_user)
        users.each do |user|
          UserMailer.deliver_comment_recipe(@comment, user)
        end
        format.html { redirect_to user_recipe_path(@recipe.author,@recipe) + "#comment-#{@comment.id}" }
        format.xml { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render user_recipe_path(@recipe.author,@recipe) + "#comment-#{@comment.id}" }
        format.xml { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

end
