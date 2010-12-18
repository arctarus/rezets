class HomeController < ApplicationController

  def index
    @recipes = Recipe.order("created_at desc").limit(8)
    @categories = Category.with_recipes.order("name asc")
    @users = User.featured
    @page_identifier = "home"
  end

  def feed
    @recipes = Recipe.all(:order => "created_at desc", :limit => 5)
    respond_to do |format|
      format.rss { render :layout => false, 
                          :action => "feed" }
    end
  end

  def about
    @page_class = "single"
  end

  def feedback
  end

  def send_feedback
    UserMailer.feedback(params[:feedback]).deliver
    flash[:notice] = _("thanks for your help")
    redirect_to root_url
  end
  
  def search
  end

 end
