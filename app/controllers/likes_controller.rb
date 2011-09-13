class LikesController < ApplicationController
  layout 'users'
  load_and_authorize_resource :user, :find_by => :slug

  def index
    @recipes = @user.likes.order("updated_at asc").paginate :per_page => 10, :page => params[:page]
    render 'follows/index'
  end

end
