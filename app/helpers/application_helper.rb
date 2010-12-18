module ApplicationHelper

  def title(title)
    content_for :title, title
  end

  def page_title
    page_title = if content_for? :title
      content_for(:title) + ' - '
    end
    page_title += 'rezets.com'
  end

end
