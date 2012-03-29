class UsersController < ApplicationController
  load_and_authorize_resource :find_by => :slug, :except => [:new, :create]
  respond_to :html, :rss
  layout 'application', :except => :show

  before_filter :require_user, :only => [:edit, :update]
  before_filter :require_no_user, :only => [:new, :create]


  def index
    @users = @users.featured.paginate :per_page => 12,
                                      :page => params[:page]
  end

  def rookies
    @users = User.rookies.paginate :per_page => 12,
                                   :page => params[:page]
    render :index
  end

  def show
    @recipes = @user.recipes.user_page(params[:order]).
      paginate :page => params[:page], :per_page => 10
    @categories = @user.categories.order(:name)
    render :layout => 'users'
  end

  def new
    @invitation = Invitation.find_by_token! params[:token]
    raise ActiveRecord::RecordNotFound if @invitation.expired?
    @user = User.new(:email => @invitation.email)
  end

  def create
    @invitation = Invitation.find_by_token! params[:invitation][:token]
    @user = User.new(params[:user])
    if @user.save
      @invitation.accepted_by @user
      @user.authenticate!
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    @user.update_attributes(params[:user])
    respond_with @user
  end

end
