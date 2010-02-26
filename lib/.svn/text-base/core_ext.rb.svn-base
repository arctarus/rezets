class String
  # Iconv use borrowed from http://svn.robertrevans.com/plugins/Permalize/
  # Thanks!
  def to_slug
      #(Iconv.new('US-ASCII//TRANSLIT', 'utf-8').iconv self).gsub(/[^\w\s\-\â€”]/,'').gsub(/[^\w]|[\_]/,' ').split.join('-').downcase 
      ActiveSupport::Multibyte::Handlers::UTF8Handler.
      		normalize(self,:d).split(//u).reject { |e| e.length > 1 }.join.strip.gsub(/[^a-z0-9]+/i, '-').downcase 
  end
end
