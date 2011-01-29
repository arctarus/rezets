module ApplicationHelper

  def title(title = nil)
    if title.blank?
      if content_for? :title
        content_for(:title)
      else
        title = 'rezets.com'
      end
    else
      content_for :title, title
    end
  end

  def meta_description(description = nil)
    content_for :meta_description, description
  end

  def meta_keywords(keywords = [])
    content_for :meta_keywords do
      keywords.join(", ")
    end
  end

end
