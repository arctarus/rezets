class HomeController < ApplicationController
  layout 'base'

  def index
    @recipes = Recipe.all(:order => "created_at desc", :limit => 8, :include => :author)
    @categories = Category.with_recipes
#   @users = User.featured
    @page_identifier = "home"
    @page_title = _("share your recipes")
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
    UserMailer.feedback(params[:feedback]).deliver
    flash[:notice] = _("thanks for your help")
    redirect_to :action => "index"
  end
  
  def search
  end

 end
