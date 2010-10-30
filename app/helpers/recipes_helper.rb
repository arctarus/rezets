module RecipesHelper

  def add_ingredient_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :recipe_ingredients_body, :partial => "ingredient", :object => RecipeIngredient.new
    end
  end

  def round(x)
    if x == 0.5
      "1/2"
    elsif x == 0.25
      "1/4"
    elsif x == 0.3
      "1/3"
    elsif x == 0.2
      "1/5"
    else
      x == x.round ? x.round : x
    end
  end

  def email(recipe)
    render :partial => 'email', :locals => { :recipe => recipe }
  end

  def twitter(recipe)
    _("tasty and substance %{recipe} recipe %{url}") % {:recipe => recipe.name.downcase, :url => user_recipe_url(recipe.author,recipe)}
  end

  def facebook_sharer_url(recipe)
    "http://www.facebook.com/sharer.php?u=#{recipe_url(recipe)}&t=" + 
    _("%{recipe} recipe by %{author}") % {
      :recipe => recipe.name.downcase,
      :author => recipe.author.name }
  end

  def email_send
    render :partial => 'email_send'
  end

end
