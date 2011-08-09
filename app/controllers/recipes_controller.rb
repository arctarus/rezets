class RecipesController < ApplicationController
  respond_to :html
  before_filter :require_user, :except => [:index, :show, :email, :email_send]
  before_filter :find_recipe, :except => [:index, :new, :create, :edit, :update, :destroy]

  # GET /recipes
  # GET /recipes.xml
  def index
    @recipes = @recipes.order("likes_count desc, updated_at desc").
      paginate :per_page => 10, :page => params[:page]
    @categories = Category.with_recipes.order("name asc")
  end

  # GET /recipes/1
  # GET /recipes/1.xml
  def show
    @recipes_same_author = Recipe.by_author(@recipe.author.id).not_in(@recipe.id).limit(3)
    @recipes_same_category = Recipe.by_category(@recipe.category.id).
      not_in(@recipes_same_author.map(&:id).push(@recipe.id)).limit(3)
    @print = params[:print].to_i == 1
    render :layout => 'recipe'
  end

  # GET /recipes/new
  # GET /recipes/new.xml
  def new
    @recipe = current_user.authorings.new
    @recipe.recipe_ingredients.build
  end

  # POST /recipes
  # POST /recipes.xml
  def create
    @recipe = current_user.authorings.new(params[:recipe])
    @recipe.users << current_user
    if @recipe.save
    end
    respond_with @recipe, :location => current_user
  end

  # GET /recipes/1/edit
  def edit
    @recipe = current_user.authorings.find(params[:id])
  end

  # PUT /recipes/1
  # PUT /recipes/1.xml
  def update
    @recipe = current_user.authorings.find(params[:id])
    @recipe.updated_at = Time.now
    if @recipe.update_attributes(params[:recipe])
    else
      @categories = Category.all
    end
    respond_with @recipe, :location => current_user
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.xml
  def destroy
    @recipe = current_user.recipes.find(params[:id], :include => :ingredients)
    @recipe.destroy
    respond_with @author
  end

  # GET /user/arctarus/recipes/1-perdices/email
  def email
    if request.xhr?
      render :update do |page|
        page << "if (!$('email-container')){"
        page.insert_html :before, 'action-links', 
          "<div id=\"email-container\"></div>"
        page.insert_html :top, 'email-container', email(@recipe)
        page << "}"
        page << "var cos = $('send-email').positionedOffset();"
        page << "$('email-container').setStyle({left:cos[0] + 'px'})";
      end
    end
  end

  # POST /user/arctarus/recipes/1-perdices/email
  def email_send
    if request.xhr?
      if (current_user.nil? and params[:email][:name].blank?) or params[:email][:recipients].blank?
        render :update do |page|
          page.select('#email-container p.error').each do |error|
            error.remove
          end
          page.remove "ajax-indicator"
          if current_user.nil? and params[:email][:name].blank?
            page.insert_html :before, 'email_name',
              '<p class="error">' + _("please, enter your name") + '</p>'
          end
          if params[:email][:recipients].blank?
            page.insert_html :before, 'email_recipients',
              '<p class="error">' + _("please, enter the email address for a friend") + '</p>'
          end
        end
      else
        UserMailer.recipe(@recipe, params[:email], current_user).deliver
        render :update do |page|
          page.replace_html "send-email-wrapper", email_send
        end
      end
    else
      redirect_to user_recipe_path(@recipe.author,@recipe)
    end
  end

  def like
    current_user.likes << @recipe
  end

  def unlike
    current_user.recipe_likes.find_by_recipe_id(@recipe.id).destroy
    render 'like'
  end

  private
    def find_recipe
      recipe_id = params[:id].split("-").first
      @author = User.find_by_slug params[:user_id]
      @recipe = @author.recipes.find(recipe_id, :include => :ingredients)
    end

end
