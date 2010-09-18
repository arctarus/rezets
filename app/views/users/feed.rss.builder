xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title _("#{@user.name}'s recipes on rezets.com")
    xml.description _("#{@user.name}'s latests recipes")
    xml.link user_url(@user)
 
    for recipe in @recipes
      xml.item do
        xml.title recipe.name
        xml.category recipe.category.name
        xml.author recipe.author.name
        xml.description recipe.directions
        xml.enclosure :url => request.protocol + request.host_with_port + recipe.photo(:large), :length => recipe.photo_file_size, :type => recipe.photo_content_type
        xml.pubDate recipe.created_at.to_s(:rfc822)
        xml.link user_recipe_url(@user, recipe)
      end
    end
  end
end
