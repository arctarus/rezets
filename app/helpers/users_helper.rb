module UsersHelper

  def user_title(user, category = nil, page = 1)
    if category
      title = _("%{user}'s %{category} recipes") % {:user => user.name, :category => category.name}
    else
      title = _("%{user}'s recipes") % {:user => user.name}
    end
    if page > 1
      title << ' ' + _("page %{num}") % {:num => page}
    end
    title
  end

  def link_to_new_recipe(user)
    if current_user == @user and can? :create, Recipe
      content_tag :p do
        link_to _('create a new recipe'), new_user_recipe_path(current_user)
      end
    end
  end

  def user_categories_sidebar(user, categories)
    content_for :sidebar do
      render 'users/sidebar', user: @user, categories: @categories
    end
  end

  def welcome_or_blank(user, current_user)
    if current_user and user == current_user
      render 'welcome', user: user
    else
      render 'blank_recipes', user: user
    end
  end

  def nav_link_unless(condition, name, options = {}, html_options = {})
    current_page = current_page? options
    content_tag :h2, :class => current_page && :current do
      link_to_unless(condition, name, options, html_options)
    end
  end

  def num_recipes(num)
    n_("%{num} recipe", "%{num} recipes", num) % {:num => num}
  end

  def num_follows(num)
    n_("%{num} following", "%{num} followings", num) % {:num => num}
  end

  def num_likes(num)
    n_("%{num} like", "%{num} likes", num) % {:num => num}
  end

  def link_to_user_avatar(user, size = :medium)
    link_to image_tag(user.avatar.url(size),
      class: 'avatar', alt:''), user
  end

end
