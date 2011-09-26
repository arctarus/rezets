class FollowsController < ApplicationController
  layout 'users'
  load_and_authorize_resource :user, :find_by => :slug
  respond_to :html, :xml, :json

  def index
    @recipes = Recipe.where(:author_id => @user.followings.map(&:id)).
      order("updated_at desc").
      paginate :per_page => 10, :page => params[:page]
    respond_with @recipes
  end

  def create
    current_user.followings << @user
    respond_to do |format|
      format.js
    end
  end

  def destroy
    current_user.follow_followings.find_by_following_id(@user.id).destroy
    respond_to do |format|
      format.js { render 'create' }
    end
  end

end
