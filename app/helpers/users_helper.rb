module UsersHelper
  def user_title(user, category = nil, page = 1)
    if category
      title = _("%{user}'s %{category} recipes") % {:user => user.name, :category => category.name}
    else
      title = _("%{user}'s recipes") % {:user => user.name}
    end
    title << ' ' + _("page %{num}") % {:num => page} if page > 1
    title
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
end
