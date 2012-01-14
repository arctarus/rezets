class HomeController < ApplicationController
  respond_to :html, :except => :feed

  def index
    @recipes = Recipe.freshly_made
    @categories = Category.with_recipes.order("name asc")
    @users = User.featured.limit(8)
  end

  def feed
    @recipes = Recipe.order("created_at desc").limit(8)
    render :template => 'home/feed.rss', :type => :builder
  end

  def about
  end

  def search
  end

 end
