module ApplicationHelper

  def title(title = nil)
    if title.nil?
      if content_for? :title
        content_for(:title)
      else
        title = 'rezets.com'
      end
    else
      content_for :title, title
      title
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

  def blog_url
    "http://blog.rezets.com"
  end

  def twitter_url
    "http://twitter.com/rezets"
  end

  def facebook_url
    "http://facebook.com/rezets" 
  end

end
