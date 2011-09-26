xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "rezets.com"
    xml.description _("rezets.com - freshly made recipes")
    xml.link "http://rezets.com"
 
    for recipe in @recipes
      xml.item do
        xml.title recipe.name
        xml.category recipe.category.name
        xml.author @user.name
        xml.description recipe.directions
        xml.enclosure :url => recipe.photo(:large), :length => recipe.photo_file_size, :type => recipe.photo_content_type
        xml.pubDate recipe.created_at.to_s(:rfc822)
        xml.link [@user, recipe]
      end
    end
  end
end
