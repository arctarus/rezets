class RecipesController < ApplicationController
  layout 'base'
  
  before_filter :require_user, :only => [:new, :create, :edit, :update, :destroy, :save, :remove]  
  before_filter :find_recipe, :only => [:show, :edit, :update, :destroy, :email, :email_send]

  # GET /recipes
  # GET /recipes.xml
  def index
    @featured_recipe = Recipe.random
    @categories = Category.all(:order => "name asc", :include => :recipes)
    @categories.delete_if {|c| c.recipes.blank? }
    @page_title = _("recipes")
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @recipes }
    end
  end

  # GET /recipes/1
  # GET /recipes/1.xml
  def show
    @comments = @recipe.comments.paginate(:page => params[:page], :per_page => 20)
    @comment = Comment.new unless current_user.nil?
    @page_title = @recipe.title
    @page_class = "hrecipe"
    @recipes_same_author = Recipe.by_author(@recipe.author.id).
      not_in(@recipe.id)
    @recipes_same_category = Recipe.by_category(@recipe.category.id).
      not_in(@recipes_same_author.map(&:id).push(@recipe.id))
    @print = params[:print].to_i == 1
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @recipe }
    end
  end

  # GET /recipes/new
  # GET /recipes/new.xml
  def new
    @page_title = _("new recipe")
    @categories = Category.all(:order => "name asc")
    @recipe = Recipe.new
    @recipe.recipe_ingredients.build
    @recipe.author = @user
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @recipe }
    end
  end

  # GET /recipes/1/edit
  def edit
    @categories = Category.all(:order => "name asc")
    @page_title = _("editing %{recipe}") % {:recipe => @recipe.name}
  end

  # POST /recipes
  # POST /recipes.xml
  def create
    @recipe = Recipe.new(params[:recipe])
    @recipe.author = current_user
    @recipe.users << current_user
    respond_to do |format|
      if @recipe.save
        flash[:notice] = _('recipe created')
        format.html { redirect_to current_user }
        format.xml  { render :xml => @recipe, :status => :created, :location => @recipe }
      else
        @categories = Category.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @recipe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /recipes/1
  # PUT /recipes/1.xml
  def update
    @recipe.updated_at = Time.now
    respond_to do |format|
      if @recipe.update_attributes(params[:recipe])
        flash[:notice] = _('recipe update')
        format.html { redirect_to(current_user) }
        format.xml  { head :ok }
      else
        @categories = Category.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recipe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.xml
  def destroy
    author = @recipe.author
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to author }
      format.xml  { head :ok }
    end
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

  # POST /recipes/1/save
# def save
#   recipe = Recipe.find params[:id]
#   current_user.recipes << recipe
#   redirect_to user
# end

# # POST /recipes/1/remove
# def remove
#   recipe = Recipe.find params[:id]
#   current_user.recipes.delete(recipe)
#   redirect_to user
# end


  private
    def find_recipe
      recipe_id = params[:id].split("-").first
      @author = User.find_by_slug params[:user_id]
      @recipe = Recipe.find_by_id_and_author_id(recipe_id, @author.id, 
        :include => :ingredients)
    end

end
