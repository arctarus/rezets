# coding: utf-8
class UsersController < ApplicationController
  respond_to :html
  before_filter :require_user, :only => [:edit, :update, :changepassword, :updatepassword]
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :find_user, :only => [:show, :edit, :update,
    :changepassword, :updatepassword, :follow, :unfollow,
    :following, :likes]

  def index
    @users = User.paginate :per_page => 50, :page => params[:page]
  end

  # GET /user/arctarus
  # GET /user/arctarus.xml
  def show
    conditions = { :user_recipes => { :user_id => @user.id } }
    @total_recipes = Recipe.joins(:user_recipes).where(conditions).count
    unless params[:category_id].nil?
      @category = Category.find_by_slug params[:category_id]
      conditions[:category_id] = @category.id
    end
    order = params[:order] != "name" ? "updated_at desc" : "name asc" 
    @recipes = Recipe.joins(:user_recipes).where(conditions).order(order).  paginate(:page => params[:page], :per_page => 10)
    @categories = Category.joins(:recipes).where({:recipes => { :author_id => @user.id }}).uniq
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @invitation = Invitation.find_by_token(params[:id])
    if not @invitation.nil? and @invitation.created_at >= Time.now - 1.week
      @user = User.new(:email => @invitation.email)
      @user = User.new
    else
      render :layout => false, :file => '/public/404.html', :status => 404
    end
  end

  def create
    @invitation = Invitation.find_by_token(params[:invitation][:token])
    @user = User.new(params[:user])
    @user_session = UserSession.new({
      :email => params[:user][:email],
      :password => params[:user][:password]
    })
    respond_to do |format|
      if not @invitation.nil? and @user.save and @user_session.save
        @invitation.update_attributes({
          :updated_at => Time.now,
          :receiver_id => @user.id })
        flash[:notice] = "Bienvenido a rezets.com"
        format.html { redirect_back_or_default @user_session.user }
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /users/arctarus/profile
  def edit
    @page_title = "editar perfil de #{@user.name}"
  end

  # PUT /users/arctarus
  # PUT /users/arctarus/1.xml
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'perfil actualizado correctamente'
        format.html { redirect_to @user }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def changepassword
  end

  def updatepassword
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'password updated'
        format.html { redirect_to @user }
        format.xml  { head :ok }
      else
        format.html { render :action => "changepassword" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def follow
    current_user.followings << @user
  end

  def unfollow
    current_user.followings.delete(@user)
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

  private

  def find_user
    @user = User.find_by_slug params[:id]
  end

end
