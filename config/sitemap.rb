# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://rezets.com"

SitemapGenerator::Sitemap.add_links do |sitemap|
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: sitemap.add path, options
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly', 
  #           :lastmod => Time.now, :host => default_host

  # statics
  sitemap.add '/about', :priority => 0.7
  sitemap.add '/feedback', :priority => 0.7
  sitemap.add '/search', :priority => 0.7
  sitemap.add '/feed', :priority => 0.7
  sitemap.add '/locale', :priority => 0.7

  # recipes
  sitemap.add recipes_path, :priority => 0.7
  Recipe.find_each do |r|
    sitemap.add user_recipe_path(r.author, r), :lastmod => r.updated_at
  end

  # users
  User.find_each(:include => :recipes) do |u|
    sitemap.add user_path(u), :lastmod => u.recipes.last.updated_at unless u.recipes.blank?
  end

  sitemap.add categories_path, :priority => 0.7
  # categories
  Category.find_each(:include => :recipes) do |c|
    sitemap.add category_path(c), :lastmod => c.recipes.last.updated_at unless c.recipes.blank?
  end
  
end

# Including Sitemaps from Rails Engines.
#
# These Sitemaps should be almost identical to a regular Sitemap file except 
# they needn't define their own SitemapGenerator::Sitemap.default_host since
# they will undoubtedly share the host name of the application they belong to.
#
# As an example, say we have a Rails Engine in vendor/plugins/cadability_client
# We can include its Sitemap here as follows:
# 
# file = File.join(Rails.root, 'vendor/plugins/cadability_client/config/sitemap.rb')
# eval(open(file).read, binding, file)
