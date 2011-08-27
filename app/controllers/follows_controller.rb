class FollowsController < ApplicationController
  layout 'users'
  load_and_authorize_resource :user, :find_by => :slug

  def index
    @recipes = Recipe.where(:author_id => @user.followings.map(&:id)).
      order("updated_at desc").
      paginate :per_page => 10, :page => params[:page]
  end

  def create
    current_user.followings << @user
  end

  def destroy
    current_user.follow_followings.find_by_following_id(@user.id).destroy
    render 'create'
  end

end
