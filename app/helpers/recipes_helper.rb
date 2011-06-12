module RecipesHelper

  def add_ingredient_link(name, url)
    template = render(:partial => 'ingredient', :object => RecipeIngredient.new)
    js = "$(\"recipe_ingredients_body\").insert({bottom: \"#{escape_javascript(template)}\"}); return false;"
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
    render :partial => 'email', :locals => { :recipe => recipe }
  end

  def link_to_print(recipe)
    link_to_function _('print'), "window.open(this.href)",
      :href => user_recipe_path(recipe.author,recipe, :print => 1),
      :class => 'action-link print'
  end

  def link_to_twitter(recipe)
    link_to "twitter", "http://twitter.com/home?status=#{twitter_status_example(recipe)}",
      :class => 'action-link twitter',
      :title => _('share recipe on twitter')
  end

  def twitter_status_example(recipe)
    _("tasty and substance %{recipe} recipe %{url}") % {
      :recipe => recipe.name.downcase, 
      :url => user_recipe_url(recipe.author,recipe)}
  end

  def link_to_facebook(recipe)
    link_to "facebook", facebook_sharer_url(recipe), 
      :class => 'action-link facebook', 
      :title => _('share recipe on facebook')
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
