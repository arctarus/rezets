class HomeController < ApplicationController
  layout 'base'

  def index
    unless current_user.nil?
      redirect_to current_user
    else
      @recipes = Recipe.all(:order => "created_at desc", :limit => 5)
      @categories = Category.all(:order => "name")
      @categories.delete_if {|c| c.recipes.blank? }
      @users = User.all(:order => "created_at desc", :limit => 8)
      @comments = Comment.all(:order => "created_at desc", :limit => 5)
      @page_identifier = "home"
      @page_title = _("share your recipes")
    end
  end

  def feed
    @recipes = Recipe.all(:order => "created_at desc", :limit => 5)
    respond_to do |format|
      format.rss { render :layout     => false, 
                          :action     => "feed" }
    end
  end

  def about
    @page_class = "single"
    @page_title = _("about rezets.com")
  end

  def feedback
    @page_title = _("contact with us")
  end

  def send_feedback
    UserMailer.deliver_feedback(params[:feedback])
    flash[:notice] = _("thanks for your help")
    redirect_to :action => "index"
  end
  
  def search
  end

  def locale
    cookies["lang"] = params[:id]
    redirect_to :action => :index
  end

 end
