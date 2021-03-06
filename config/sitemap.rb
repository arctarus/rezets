SitemapGenerator::Sitemap.default_host = APP_CONFIG['app_domain']
SitemapGenerator::Sitemap.sitemaps_host = "http://s3.amazonaws.com/#{ENV['S3_BUCKET']}/"
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.include_index = false
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
  aws_access_key_id: ENV['S3_KEY'],
  aws_secret_access_key: ENV['S3_SECRET'],
  fog_provider: 'AWS',
  fog_directory: 'rezets'
)

SitemapGenerator::Sitemap.create do
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
  add '/about', :priority => 0.7
  add '/feedback', :priority => 0.7
  add '/search', :priority => 0.7
  add '/feed', :priority => 0.7
  add '/locale', :priority => 0.7

  # recipes
  add recipes_path, :priority => 0.7
  Recipe.find_each do |r|
    add user_recipe_path(r.author, r), :lastmod => r.updated_at
  end

  # users
  User.find_each(:include => :recipes) do |u|
    add user_path(u), :lastmod => u.recipes.last.updated_at if u.recipes.present?
  end

  add categories_path, :priority => 0.7
  # categories
  Category.find_each(:include => :recipes) do |c|
    add category_path(c), :lastmod => c.recipes.last.updated_at if c.recipes.present?
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
