class RecipesController < ApplicationController
  respond_to :html
  before_filter :require_user, :except => [:index, :show]
  before_filter :find_recipe, :except => [:index, :new, :create]

  # GET /recipes
  # GET /recipes.xml
  def index
    @categories = Category.with_recipes.order("name asc")
  end

  # GET /recipes/1
  # GET /recipes/1.xml
  def show
    @comments = @recipe.comments.paginate(:page => params[:page], :per_page => 20)
    @comment = Comment.new unless current_user.nil?
    @recipes_same_author = Recipe.by_author(@recipe.author.id).
      not_in(@recipe.id).limit(5)
    @recipes_same_category = Recipe.by_category(@recipe.category.id).
      not_in(@recipes_same_author.map(&:id).push(@recipe.id)).limit(5)
    @print = params[:print].to_i == 1
  end

  # GET /recipes/new
  # GET /recipes/new.xml
  def new
    @author = User.find_by_slug params[:user_id]
    @recipe = @author.recipes.new
    @recipe.recipe_ingredients.build
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes
  # POST /recipes.xml
  def create
    @author = User.find_by_slug params[:user_id]
    @recipe = @author.recipes.new(params[:recipe])
    @recipe.users << current_user
    respond_to do |format|
      if @recipe.save
        flash[:notice] = _('recipe created')
        format.html { redirect_to current_user }
        format.xml  { render :xml => @recipe, :status => :created, :location => @recipe }
      else
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
    @recipe.destroy
    respond_with(@author)
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

  private
    def find_recipe
      recipe_id = params[:id].split("-").first
      @author = User.find_by_slug params[:user_id]
      @recipe = Recipe.find_by_id_and_author_id(recipe_id, @author.id, 
        :include => :ingredients)
    end

end
