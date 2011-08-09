class UsersController < ApplicationController
  load_and_authorize_resource :find_by => :slug
  respond_to :html
  before_filter :require_user, :only => [:edit, :update, :changepassword, :updatepassword]
  before_filter :require_no_user, :only => [:new, :create]

  def index
    @users = @users.featured.paginate :per_page => 12, :page => params[:page]
    render :layout => 'application'
  end

  def rookies
    @users = User.rookies.paginate :per_page => 12, :page => params[:page]
    render :action => :index, :layout => 'application'
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
    render :layout => 'application'
  end

  def create
    @invitation = Invitation.find_by_token!(params[:invitation][:token])
    @user = User.new(params[:user])
    @user_session = UserSession.new({
      :email => params[:user][:email],
      :password => params[:user][:password]
    })
    if @user.save and @user_session.save
      @invitation.update_attributes({
        :updated_at => Time.now,
        :receiver_id => @user.id })
    end
    respond_with @user
  end

  def edit
    render :layout => 'application'
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
    @recipes = @user.followings.map(&:recipes).flatten.
      sort_by{|r| r.updated_at }.reverse.paginate :per_page => 10, :page => params[:page]
  end

  def likes
    @recipes = @user.likes.order("updated_at asc").paginate :per_page => 10, :page => params[:page]
    render 'following'
  end

end
