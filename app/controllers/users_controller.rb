class UsersController < ApplicationController
  load_and_authorize_resource :find_by => :slug
  respond_to :html
  before_filter :require_user, :only => [:edit, :update]
  before_filter :require_no_user, :only => [:new, :create]

  def index
    @users = @users.featured.paginate :per_page => 12, :page => params[:page]
  end

  def rookies
    @users = User.rookies.paginate :per_page => 12, :page => params[:page]
    render :index
  end

  def show
    conditions = { :user_recipes => { :user_id => @user.id } }
    @total_recipes = Recipe.joins(:user_recipes).where(conditions).count
    unless params[:category_id].nil?
      @category = Category.find_by_slug params[:category_id]
      conditions[:category_id] = @category.id
    end
    order = params[:order] != "name" ? "updated_at desc" : "name asc" 
    @recipes = Recipe.joins(:user_recipes).where(conditions).order(order).
      includes(:category, :recipe_ingredients => :ingredient).
      paginate(:page => params[:page], :per_page => 10)
    @categories = Category.joins(:recipes).where({:recipes => { :author_id => @user.id }}).uniq
  end

  def new
    @invitation = Invitation.find_by_token!(params[:token])
    raise ActiveRecord::RecordNotFound if @invitation.expired?
    @user = User.new(:email => @invitation.email)
  end

  def create
    @invitation = Invitation.find_by_token!(params[:invitation][:token])
    @user = User.new(params[:user])
    if @user.save
      @invitation.accepted_by @user
      @user.authenticate!
    end
    respond_with @user, :location => @user
  end

  def edit
  end

  def update
    @user.update_attributes(params[:user])
    respond_with @user
  end

  def follow
    current_user.followings << @user
    render 'follow'
  end

  def unfollow
    current_user.follow_followings.find_by_following_id(@user.id).destroy
    render 'follow'
  end

  def following
    @recipes = Recipe.where(:author_id => @user.followings.map(&:id)).
      order("updated_at desc").paginate :per_page => 10, :page => params[:page]
  end

  def likes
    @recipes = @user.likes.order("updated_at asc").paginate :per_page => 10, :page => params[:page]
    render 'following'
  end

end
