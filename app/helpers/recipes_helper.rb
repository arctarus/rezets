module RecipesHelper

  def add_ingredient_link(name, url)
    template = render :partial => 'ingredient', :object => RecipeIngredient.new
    js = "$(\"#recipe_ingredients_body\").append(\"#{escape_javascript(template)}\"); return false;"
    link_to name, '#', :remote => true, :onclick => js
  end

  def round(x)
    if x == 0.5
      "&frac12;".html_safe
    elsif x == 0.25
      "&frac14;".html_safe
    elsif x == 0.3
      "&#8531;".html_safe
    elsif x == 0.2
      "&#8533;".html_safe
    else
      x == x.round ? x.round : x
    end
  end

  def email(recipe)
    render 'email', recipe: recipe
  end

  def link_to_print(recipe)
    link_to _('print'), print_user_recipe_path(recipe.author,recipe), 
      class: 'action-link print new-window',
      rel: 'nofollow'
  end

  def add_this(recipe)
    render 'recipes/add_this', 
      url: user_recipe_url(recipe.author, recipe),
      title: add_this_description(recipe),
      description: recipe.title
  end

  def add_this_description(recipe)
    _("tasty and substance %{recipe} recipe") % {
      recipe: recipe.name.downcase }
  end

  def recipe_image_tag(recipe)
    image_tag recipe.photo.url(:large),
      class: "photo",
      alt: recipe.title,
      title: recipe.title
  end

  def join_recipients(recipients)
    Array(recipients).join('; ')
  end

  def recipe_cook_time(recipe)
    return if @recipe.cook_time.blank?
    render 'recipes/cook_time', :cook_time => @recipe.cook_time
  end

end
