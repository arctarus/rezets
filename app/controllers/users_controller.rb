# coding: utf-8

class UsersController < ApplicationController
  layout 'base'
  before_filter :require_user, :only => [:edit, :update, :changepassword, :updatepassword]
  before_filter :require_no_user, :only => [:new, :create]

  # GET /user/arctarus
  # GET /user/arctarus.xml
  def show
    @user = User.find_by_slug params[:id]
    @page_title = "recetas de #{@user.name}"
    conditions = { :user_recipes => { :user_id => @user.id } }
    @total_recipes = Recipe.joins(:user_recipes).where(conditions).count
    
    unless params[:category_id].nil?
      @category = Category.find_by_slug params[:category_id]
      conditions[:category_id] = @category.id
      @page_title << " de #{@category.name}"
    end

    order = params[:order] != "name" ? "updated_at desc" : "name asc" 
    @recipes = Recipe.joins(:user_recipes).where(conditions).order(order).
      paginate(:page => params[:page], :per_page => 10)

    @categories = Category.joins(:recipes).where({:recipes => { :author_id => @user.id }}).uniq
    @page_title << " page #{params[:page]}" unless params[:page].nil? or params[:page].to_i == 1
    respond_to do |format|
      format.html
      format.rss { render :layout => false, :action => "feed" }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @invitation = Invitation.find_by_token(params[:id])
    if not @invitation.nil? and @invitation.created_at >= Time.now - 1.week
      @user = User.new(:email => @invitation.email)
      @user = User.new
      respond_to do |format|
        format.html # new.html.eb
        format.xml { render :xml => @user }
      end
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
    @user = User.find_by_slug params[:id]
    @page_title = "editar perfil de #{@user.name}"
  end

  # PUT /users/arctarus
  # PUT /users/arctarus/1.xml
  def update
    @user = User.find_by_slug params[:id]
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
    @user = User.find_by_slug params[:id]
    @page_title = "cambiar tu password de rezets.com"
  end

  def updatepassword
    @user = User.find_by_slug params[:id]
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

end
