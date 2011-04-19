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
end
